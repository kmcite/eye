import 'package:eye/domain/repositories/sync_repository.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/objectbox.g.dart';

import 'dart:async' show unawaited;

import 'package:eye/utils/objectbox.dart';
import 'package:eye/utils/infrastructure.dart';

final usersRepositoryProvider = provider(
  () => UsersRepository(syncRepositoryProvider()),
);

class UsersRepository {
  UsersRepository(this._sync);

  final SyncRepository _sync;
  Box<AppUser> get _users => objectBox<AppUser>();

  Future<List<AppUser>> getUsers({int perPage = 50}) async {
    final all = _users.getAll()..sort((a, b) => b.created.compareTo(a.created));
    return all.take(perPage).toList();
  }

  Future<void> deleteUser(int id) async {
    final user = _users.get(id);
    if (user == null) return;
    _users.remove(id);
    _sync.enqueueUser(user, SyncOp.delete);
    unawaited(_sync.runOnce());
  }
}
