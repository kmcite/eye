import 'dart:async' show StreamController, unawaited;

import 'package:eye/domain/repositories/sync_repository.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/domain/sync_entity.dart';
import 'package:eye/objectbox.g.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/objectbox.dart';

final categoriesRepositoryProvider = provider(
  () => CategoriesRepository(syncRepositoryProvider()),
);

class CategoriesRepository {
  CategoriesRepository(this._syncRepository);

  final SyncRepository _syncRepository;
  final _changes = StreamController<List<Category>>.broadcast();

  Box<Category> get _box => objectBox<Category>();

  Stream<List<Category>> get stream => _changes.stream;

  List<Category> getAll() {
    final query = _box.query().order(Category_.name).build();
    try {
      return query.find();
    } finally {
      query.close();
    }
  }

  Future<void> initialize() async {
    _emit();
  }

  void _emit() {
    if (_changes.isClosed) return;
    _changes.add(getAll());
  }

  Category? getById(int id) => id == 0 ? null : _box.get(id);

  Future<Category> create(String name) async {
    final trimmed = name.trim();
    final now = DateTime.now().toUtc();
    final category = Category(name: trimmed, created: now, updated: now);
    _box.put(category);
    _syncRepository.enqueue(
      entityType: SyncEntity.category,
      entityKey: category.syncKey,
      operation: SyncOp.create,
      payload: _payload(category),
    );
    unawaited(_syncRepository.runOnce());
    _emit();
    return category;
  }

  Future<Category> update(int id, {required String name}) async {
    final existing = _box.get(id);
    if (existing == null) throw StateError('Category not found');
    existing
      ..name = name.trim()
      ..updated = DateTime.now().toUtc();
    _box.put(existing);
    _syncRepository.enqueue(
      entityType: SyncEntity.category,
      entityKey: existing.syncKey,
      operation: SyncOp.update,
      payload: _payload(existing),
    );
    unawaited(_syncRepository.runOnce());
    _emit();
    return existing;
  }

  Future<void> delete(int id) async {
    final existing = _box.get(id);
    if (existing == null) return;
    _syncRepository.enqueue(
      entityType: SyncEntity.category,
      entityKey: existing.syncKey,
      operation: SyncOp.delete,
      payload: _payload(existing),
    );
    _box.remove(id);
    unawaited(_syncRepository.runOnce());
    _emit();
  }

  static Map<String, dynamic> _payload(Category c) => {
    'localId': c.id,
    'syncKey': c.syncKey,
    'name': c.name,
    'created': c.created.toUtc().toIso8601String(),
    'updated': c.updated.toUtc().toIso8601String(),
  };
}
