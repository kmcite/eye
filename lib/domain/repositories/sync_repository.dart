import 'dart:async';
import 'dart:convert';

import 'package:eye/business/app_status_notifier.dart';
import 'package:eye/domain/repositories/sync_events.dart';
import 'package:eye/domain/repositories/sync_readiness.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/domain/models/sync_applied_remote.dart';
import 'package:eye/domain/models/sync_cursor.dart';
import 'package:eye/domain/models/sync_outbox_entry.dart';
import 'package:eye/domain/sync_entity.dart';
import 'package:eye/objectbox.g.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/objectbox.dart';
import 'package:eye/utils/pocketbase.dart';
import 'package:eye/utils/pocketbase_config.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:uuid/uuid.dart';

class SyncOp {
  static const create = 'create';
  static const update = 'update';
  static const delete = 'delete';
}

final syncRepositoryProvider = provider(
  () => SyncRepository(
    pb: pocketBaseProvider(),
    appStatus: appStatusNotifierProvider(),
    config: pocketBaseConfigProvider(),
    cloudReadiness: syncCloudReadinessRepositoryProvider(),
  ),
);

class SyncRepository {
  SyncRepository({
    required PocketBase pb,
    required AppStatusNotifier appStatus,
    required PocketBaseConfig config,
    required SyncCloudReadinessRepository cloudReadiness,
  }) : _pb = pb,
       _appStatus = appStatus,
       _config = config,
       _cloudReadiness = cloudReadiness;

  final PocketBase _pb;
  final AppStatusNotifier _appStatus;
  final PocketBaseConfig _config;
  final SyncCloudReadinessRepository _cloudReadiness;
  static const _uuid = Uuid();
  var _running = false;

  bool get isSyncing => _running;

  Box<SyncOutboxEntry> get _outbox => objectBox<SyncOutboxEntry>();
  Box<SyncCursor> get _cursorBox => objectBox<SyncCursor>();
  Box<SyncAppliedRemote> get _appliedBox => objectBox<SyncAppliedRemote>();
  Box<AppUser> get _users => objectBox<AppUser>();
  Box<Category> get _categories => objectBox<Category>();
  Box<Question> get _questions => objectBox<Question>();

  void enqueue({
    required String entityType,
    required String entityKey,
    required String operation,
    required Map<String, dynamic> payload,
  }) {
    _outbox.put(
      SyncOutboxEntry(
        entityType: entityType,
        operation: operation,
        entityKey: entityKey,
        payloadJson: jsonEncode(payload),
      ),
    );
    _appStatus.refreshQueueCount();
  }

  void enqueueUser(AppUser user, String operation) {
    enqueue(
      entityType: SyncEntity.appUser,
      entityKey: user.email.trim().toLowerCase(),
      operation: operation,
      payload: _userPayload(user),
    );
  }

  Future<void> runOnce() async {
    if (_running) return;
    _running = true;
    _appStatus.setSyncActive(true);
    _appStatus.refreshQueueCount();
    try {
      if (!await _cloudReadiness.ensureReady()) {
        return;
      }
      await _ensureAdminAuth();
      await _push();
      await _pull();
    } finally {
      _running = false;
      _appStatus.setSyncActive(false);
      _appStatus.refreshQueueCount();
      unawaited(_appStatus.refresh());
    }
  }

  Future<void> _ensureAdminAuth() async {
    if (_pb.authStore.isValid) return;
    final email = _config.adminEmail;
    final password = _config.adminPassword;
    if (email == null || password == null) return;
    await _pb.admins.authWithPassword(email, password);
  }

  SyncCursor get _cursor {
    var row = _cursorBox.get(1);
    if (row == null) {
      row = SyncCursor(deviceId: _uuid.v4());
      _cursorBox.put(row);
      return row;
    }
    if (row.deviceId.isEmpty) {
      row.deviceId = _uuid.v4();
      _cursorBox.put(row);
    }
    return row;
  }

  Future<void> _push() async {
    final cursor = _cursor;
    final query = _outbox.query().order(SyncOutboxEntry_.createdAt).build();
    final pending = query.find();
    query.close();
    for (final entry in pending) {
      try {
        await _pb
            .collection(syncEventsCollection)
            .create(
              body: {
                'deviceId': cursor.deviceId,
                'entityType': entry.entityType,
                'entityKey': entry.entityKey,
                'operation': entry.operation,
                'payload': jsonDecode(entry.payloadJson),
              },
            );
        _outbox.remove(entry.id);
      } catch (_) {}
    }
  }

  Future<void> _pull() async {
    final cursor = _cursor;
    final filter = cursor.lastPulledCreated.isEmpty
        ? null
        : 'created > "${cursor.lastPulledCreated.replaceAll('"', r'\"')}"';

    final page = await _pb
        .collection(syncEventsCollection)
        .getList(
          page: 1,
          perPage: 100,
          sort: 'created',
          filter: filter,
        );

    var watermark = cursor.lastPulledCreated;

    for (final record in page.items) {
      watermark = _later(watermark, record.created);
      if (record.getStringValue('deviceId') == cursor.deviceId) continue;
      if (_applied(record.id)) continue;

      _apply(record);
      _appliedBox.put(SyncAppliedRemote(remoteId: record.id));
    }

    if (watermark != cursor.lastPulledCreated) {
      cursor.lastPulledCreated = watermark;
      _cursorBox.put(cursor);
    }
  }

  bool _applied(String remoteId) {
    final query = _appliedBox
        .query(SyncAppliedRemote_.remoteId.equals(remoteId))
        .build();
    try {
      return query.findFirst() != null;
    } finally {
      query.close();
    }
  }

  void _apply(RecordModel record) {
    final type = record.getStringValue('entityType');
    final op = record.getStringValue('operation');
    final map = record.data['payload'];
    if (map is! Map) return;
    final payload = Map<String, dynamic>.from(map);

    switch (type) {
      case SyncEntity.appUser:
        _applyUser(op, record.getStringValue('entityKey'), payload);
      case SyncEntity.category:
        _applyCategory(op, record.getStringValue('entityKey'), payload);
      case SyncEntity.question:
        _applyQuestion(op, record.getStringValue('entityKey'), payload);
      default:
        return;
    }
  }

  void _applyUser(String op, String key, Map<String, dynamic> payload) {
    if (op == SyncOp.delete) {
      final user = _byEmail(key);
      if (user != null) _users.remove(user.id);
      return;
    }

    final incoming = _userFromPayload(payload);
    final local = _byEmail(key);

    if (local == null) {
      _users.put(
        AppUser(
          email: incoming.email,
          username: incoming.username,
          name: incoming.name,
          avatar: incoming.avatar,
          passwordHash: incoming.passwordHash,
          created: incoming.created,
          updated: incoming.updated,
        ),
      );
      return;
    }

    if (incoming.updated.isBefore(local.updated)) return;
    local
      ..username = incoming.username
      ..name = incoming.name
      ..avatar = incoming.avatar
      ..passwordHash = incoming.passwordHash
      ..updated = incoming.updated;
    _users.put(local);
  }

  void _applyCategory(String op, String syncKey, Map<String, dynamic> payload) {
    final local = _categoryBySyncKey(syncKey);
    if (op == SyncOp.delete) {
      if (local != null) _categories.remove(local.id);
      return;
    }

    final incoming = Category(
      id: (payload['localId'] as num?)?.toInt() ?? 0,
      syncKey: syncKey,
      name: payload['name'] as String? ?? '',
      created: DateTime.parse(payload['created'] as String),
      updated: DateTime.parse(payload['updated'] as String),
    );

    if (local == null) {
      _categories.put(incoming);
      return;
    }

    if (incoming.updated.isBefore(local.updated)) return;
    local
      ..name = incoming.name
      ..updated = incoming.updated;
    _categories.put(local);
  }

  void _applyQuestion(String op, String syncKey, Map<String, dynamic> payload) {
    final local = _questionBySyncKey(syncKey);
    if (op == SyncOp.delete) {
      if (local != null) _questions.remove(local.id);
      return;
    }

    final incoming = _questionFromPayload(payload, syncKey);

    if (local == null) {
      _questions.put(incoming);
      return;
    }

    if (incoming.updated.isBefore(local.updated)) return;
    local
      ..statement = incoming.statement
      ..options = incoming.options
      ..correctIndex = incoming.correctIndex
      ..explanation = incoming.explanation
      ..categoryId = incoming.categoryId
      ..updated = incoming.updated;
    _questions.put(local);
  }

  Category? _categoryBySyncKey(String syncKey) {
    final query = _categories.query(Category_.syncKey.equals(syncKey)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }

  Question? _questionBySyncKey(String syncKey) {
    final query = _questions.query(Question_.syncKey.equals(syncKey)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }

  AppUser? _byEmail(String email) {
    final query = _users
        .query(AppUser_.email.equals(email.trim().toLowerCase()))
        .build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }

  static Map<String, dynamic> _userPayload(AppUser user) => {
    'localId': user.id,
    'email': user.email,
    'username': user.username,
    'name': user.name,
    'avatar': user.avatar,
    'passwordHash': user.passwordHash,
    'created': user.created.toUtc().toIso8601String(),
    'updated': user.updated.toUtc().toIso8601String(),
  };

  static AppUser _userFromPayload(Map<String, dynamic> map) {
    return AppUser(
      id: (map['localId'] as num?)?.toInt() ?? 0,
      email: map['email'] as String,
      username: map['username'] as String,
      name: map['name'] as String? ?? '',
      avatar: map['avatar'] as String? ?? '',
      passwordHash: map['passwordHash'] as String? ?? '',
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  static Question _questionFromPayload(
    Map<String, dynamic> payload,
    String syncKey,
  ) {
    final options = payload['options'];
    return Question(
      id: (payload['localId'] as num?)?.toInt() ?? 0,
      syncKey: syncKey,
      statement: payload['statement'] as String? ?? '',
      options: options is List
          ? options.map((e) => e.toString()).toList()
          : const [],
      correctIndex: (payload['correctIndex'] as num?)?.toInt() ?? 0,
      explanation: payload['explanation'] as String? ?? '',
      categoryId: (payload['categoryId'] as num?)?.toInt() ?? 0,
      created: DateTime.parse(payload['created'] as String),
      updated: DateTime.parse(payload['updated'] as String),
    );
  }

  static String _later(String a, String b) {
    if (a.isEmpty) return b;
    final da = DateTime.tryParse(a);
    final db = DateTime.tryParse(b);
    if (da == null) return b;
    if (db == null) return a;
    return db.isAfter(da) ? b : a;
  }

  List<SyncOutboxEntry> listPendingOutbox() {
    final query = _outbox.query().order(SyncOutboxEntry_.createdAt).build();
    try {
      return query.find();
    } finally {
      query.close();
    }
  }

  SyncCursor? get syncCursor => _cursorBox.get(1);

  int get appliedRemoteCount => _appliedBox.count();
}
