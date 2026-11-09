import 'dart:async';

import 'package:eye/domain/repositories/categories_repository.dart';
import 'package:eye/domain/repositories/questions_repository.dart';
import 'package:eye/domain/repositories/sync_repository.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/utils/infrastructure.dart';

final syncNotifierProvider = provider(
  () => SyncNotifier(
    syncRepositoryProvider(),
    categoriesRepositoryProvider(),
    questionsRepositoryProvider(),
  ),
);

class SyncNotifier {
  SyncNotifier(
    this._repository,
    this._categories,
    this._questions,
  );

  final SyncRepository _repository;
  final CategoriesRepository _categories;
  final QuestionsRepository _questions;
  static const interval = Duration(seconds: 30);

  final autoSyncEnabled = signal(true);
  final lastCompletedAt = nullSignal<DateTime>();

  Timer? _timer;

  void start() {
    _timer?.cancel();
    unawaited(_runCycle());
    if (!autoSyncEnabled()) return;
    _timer = Timer.periodic(interval, (_) {
      if (autoSyncEnabled()) unawaited(_runCycle());
    });
  }

  void setAutoSync(bool enabled) {
    autoSyncEnabled.value = enabled;
    if (enabled) {
      start();
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  Future<void> syncNow() => _runCycle();

  void notifyChange(AppUser user, String operation) {
    _repository.enqueueUser(user, operation);
    unawaited(_runCycle());
  }

  Future<void> _runCycle() async {
    await _repository.runOnce();
    await _categories.initialize();
    _questions.refreshLocal();
    lastCompletedAt.value = DateTime.now();
  }
}
