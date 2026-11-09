import 'package:eye/domain/repositories/authentication_repository.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/domain/validation/auth_validators.dart';
import 'package:eye/utils/infrastructure.dart';

final authenticationNotifierProvider = provider(
  () => AuthenticationNotifier(authenticationRepositoryProvider()),
);

class AuthenticationNotifier with SignalAsync {
  AuthenticationNotifier(this.authRepository) {
    _restoreSession();
  }

  final AuthenticationRepository authRepository;

  final username = signal('adnanfarooqk1');
  final email = signal('adn@gmail.com');
  final password = signal('12345678');
  final passwordConfirm = signal('');
  final appUser = nullSignal<AppUser>();

  late final enabled = computed(() => !loading());
  late final authenticated = computed(() => appUser() != null);

  late final registerUsernameError = computed(() => validateName(username()));

  late final registerEmailError = computed(
    () => validateEmailRegistration(
      email(),
      () => authRepository.isEmailRegistered(email()),
    ),
  );

  late final registerPasswordError = computed(
    () => validatePassword(password()),
  );

  late final registerPasswordConfirmError = computed(
    () => validatePasswordConfirm(password(), passwordConfirm()),
  );

  late final registerUsernameTaken = computed(
    () => authRepository.isUsernameTaken(username()),
  );

  late final registerFirstFieldError = computed(() {
    final nameErr = registerUsernameError();
    if (nameErr != null) return nameErr;
    if (registerUsernameTaken()) return 'Username is already taken.';
    return registerEmailError() ??
        registerPasswordError() ??
        registerPasswordConfirmError();
  });

  late final registerFormValid = computed(
    () => registerFirstFieldError() == null,
  );

  Future<void> _restoreSession() async {
    appUser.value = authRepository.currentUser;

    authRepository.authStateChanges.listen((user) {
      appUser.value = user;
    });

    if (authRepository.isAuthenticated) {
      try {
        final user = await authRepository.refresh();
        appUser.value = user;
      } catch (_) {
        appUser.value = null;
      }
    }
  }

  Future<void> login() => run(() async {
    final user = await authRepository.login(
      email: email(),
      password: password(),
    );
    appUser.value = user;
  });

  Future<void> register() => run(() async {
    final user = await authRepository.register(
      username: username(),
      email: email(),
      password: password(),
      passwordConfirm: passwordConfirm(),
    );
    appUser.value = user;
  });

  Future<void> logout() => run(
    () async {
      await authRepository.logout();
      appUser.value = null;
    },
    (e, st) => appUser.value = null,
  );
}
