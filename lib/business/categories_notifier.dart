import 'dart:async';

import 'package:eye/domain/repositories/categories_repository.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/utils/infrastructure.dart';

final categoriesNotifierProvider = provider(
  () => CategoriesNotifier(categoriesRepositoryProvider()),
);

class CategoriesNotifier {
  CategoriesNotifier(this._repository);

  final CategoriesRepository _repository;
  StreamSubscription<List<Category>>? _streamSub;
  var _started = false;

  void ensureLoaded() {
    if (_started) return;
    _started = true;
    Future.microtask(initialize);
  }

  final categories = signal(<Category>[]);
  final loading = signal(false);
  final isSaving = signal(false);
  final error = nullSignal<Object>();
  final selected = nullSignal<Category>();
  final search = signal('');
  final name = signal('');

  late final filtered = computed(() {
    final q = search().trim().toLowerCase();
    if (q.isEmpty) return categories();
    return categories().where((e) => e.name.toLowerCase().contains(q)).toList();
  });

  late final canSave = computed(() => name().trim().isNotEmpty && !isSaving());

  Category? getById(int id) =>
      id == 0 ? null : categories().where((e) => e.id == id).firstOrNull;

  Future<void> initialize() async {
    loading.value = true;
    error.value = null;
    _streamSub ??= _repository.stream.listen(
      (items) => categories.value = items,
    );
    try {
      await _repository.initialize();
    } catch (e) {
      error.value = e;
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> create() async {
    error.value = null;
    isSaving.value = true;
    try {
      await _repository.create(name().trim());
      name.value = '';
      selected.value = null;
    } catch (e) {
      error.value = e;
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> update(Category category) async {
    error.value = null;
    isSaving.value = true;
    try {
      await _repository.update(category.id, name: name().trim());
      name.value = '';
      selected.value = null;
    } catch (e) {
      error.value = e;
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> delete(Category category) async {
    isSaving.value = true;
    try {
      await _repository.delete(category.id);
      if (selected()?.id == category.id) {
        selected.value = null;
      }
    } catch (e) {
      error.value = e;
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  void select(Category? category) {
    selected.value = category;
    name.value = category?.name ?? '';
  }

  void clearError() => error.value = null;

  void dispose() {
    _streamSub?.cancel();
    _streamSub = null;
  }
}
