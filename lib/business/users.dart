import 'package:eye/domain/models/app_user.dart';
import 'package:eye/features/auth/authentication_state.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';

final authentication = signal<int?>(null);
final users = listSignal(getAll<AppUser>());

final user = computed<AppUser?>(() {
  if (authentication() == null) return null;
  return null;
});

final userProgress = computed(() => user()?.progress.target);

final isUserEmailExists = computed(
  () => users.getByEmail(emailField()) != null,
);

extension UsersRepository on Signal<List<AppUser>> {
  AppUser? getByEmail(String value) {
    return this()
        .where((e) => e.email.toLowerCase() == value.toLowerCase())
        .firstOrNull;
  }
}
