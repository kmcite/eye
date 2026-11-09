import 'dart:async';

import 'package:eye/domain/repositories/sync_repository.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/domain/sync_entity.dart';
import 'package:eye/objectbox.g.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/objectbox.dart';

final questionsRepositoryProvider = provider(
  () => QuestionsRepository(syncRepositoryProvider()),
);

class QuestionsRepository {
  QuestionsRepository(this._syncRepository) {
    _emit();
  }

  final SyncRepository _syncRepository;

  final _changes = StreamController<List<Question>>.broadcast();

  Box<Question> get _box => objectBox<Question>();

  Stream<List<Question>> watch() => _changes.stream;

  List<Question> getAll() {
    final query = _box.query().order(Question_.id).build();
    try {
      return query.find();
    } finally {
      query.close();
    }
  }

  void _emit() {
    if (_changes.isClosed) return;
    _changes.add(getAll());
  }

  Future<Question> create(Question question) async {
    question.updated = DateTime.now().toUtc();
    _box.put(question);
    _syncRepository.enqueue(
      entityType: SyncEntity.question,
      entityKey: question.syncKey,
      operation: SyncOp.create,
      payload: _payload(question),
    );
    unawaited(_syncRepository.runOnce());
    _emit();
    return question;
  }

  Future<Question> update(Question question) async {
    question.updated = DateTime.now().toUtc();
    _box.put(question);
    _syncRepository.enqueue(
      entityType: SyncEntity.question,
      entityKey: question.syncKey,
      operation: SyncOp.update,
      payload: _payload(question),
    );
    unawaited(_syncRepository.runOnce());
    _emit();
    return question;
  }

  Future<void> delete(int id) async {
    final existing = _box.get(id);
    if (existing == null) return;
    _syncRepository.enqueue(
      entityType: SyncEntity.question,
      entityKey: existing.syncKey,
      operation: SyncOp.delete,
      payload: _payload(existing),
    );
    _box.remove(id);
    unawaited(_syncRepository.runOnce());
    _emit();
  }

  Question? getById(int id) => _box.get(id);

  static Map<String, dynamic> _payload(Question q) => {
    'localId': q.id,
    'syncKey': q.syncKey,
    'statement': q.statement,
    'options': q.options,
    'correctIndex': q.correctIndex,
    'explanation': q.explanation,
    'categoryId': q.categoryId,
    'created': q.created.toUtc().toIso8601String(),
    'updated': q.updated.toUtc().toIso8601String(),
  };

  void refreshLocal() => _emit();
}
