import '../../main.dart';

class UserRepository {
  bool get authenticated => userIdRM.state != null;
  late final userIdRM = RM.inject<int?>(
    () => null,
    persist: () => PersistState(
      key: 'user',
    ),
  );

  int? get id => userIdRM.state;

  void userId(int? userId) {
    userIdRM
      ..state = userId
      ..notify();
  }
}

final userRepository = UserRepository();
