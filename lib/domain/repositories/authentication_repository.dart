import 'dart:async' show StreamController, unawaited;
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/domain/models/auth_session.dart';
import 'package:eye/domain/repositories/sync_repository.dart';
import 'package:eye/domain/validation/auth_validators.dart';
import 'package:eye/objectbox.g.dart';
import 'package:eye/utils/objectbox.dart';
import 'package:eye/utils/infrastructure.dart';

final authenticationRepositoryProvider = provider(
  () => AuthenticationRepository(syncRepositoryProvider()),
);

class AuthenticationRepository {
  AuthenticationRepository(this._sync);

  final SyncRepository _sync;

  Box<AppUser> get _users => objectBox<AppUser>();
  Box<AuthSession> get _sessions => objectBox<AuthSession>();

  final _authChanges = StreamController<AppUser?>.broadcast();

  Stream<AppUser?> get authStateChanges => _authChanges.stream;

  AppUser? get currentUser {
    final userId = _session.userId;
    if (userId == 0) return null;
    return _users.get(userId);
  }

  bool get isAuthenticated => currentUser != null;

  AuthSession get _session {
    final existing = _sessions.get(1);
    if (existing != null) return existing;
    final created = AuthSession();
    _sessions.put(created);
    return created;
  }

  bool isEmailRegistered(String email) =>
      _findByEmail(email.trim().toLowerCase()) != null;

  bool isUsernameTaken(String username) =>
      _findByUsername(username.trim()) != null;

  Future<AppUser> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final trimmedUsername = username.trim();
    final trimmedEmail = email.trim().toLowerCase();

    final nameErr = validateName(trimmedUsername);
    if (nameErr != null) throw Exception(nameErr);
    if (isUsernameTaken(trimmedUsername)) {
      throw Exception('Username is already taken.');
    }

    final emailErr = validateEmailRegistration(
      trimmedEmail,
      () => isEmailRegistered(trimmedEmail),
    );
    if (emailErr != null) throw Exception(emailErr);

    final pwdErr = validatePassword(password);
    if (pwdErr != null) throw Exception(pwdErr);

    final confirmErr = validatePasswordConfirm(password, passwordConfirm);
    if (confirmErr != null) throw Exception(confirmErr);

    final now = DateTime.now();
    final user = AppUser(
      email: trimmedEmail,
      username: trimmedUsername,
      passwordHash: _hashPassword(password),
      created: now,
      updated: now,
    );

    try {
      _users.put(user);
    } on UniqueViolationException {
      throw Exception('Email or username is already taken.');
    }

    _setSession(user.id);
    _authChanges.add(user);
    _sync.enqueueUser(user, SyncOp.create);
    unawaited(_sync.runOnce());
    return user;
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();

    final emailErr = validateEmailForLogin(
      trimmedEmail,
      () => isEmailRegistered(trimmedEmail),
    );
    if (emailErr != null) throw Exception(emailErr);

    final pwdErr = validatePassword(password);
    if (pwdErr != null) throw Exception(pwdErr);

    final user = _findByEmail(trimmedEmail);
    if (user == null || user.passwordHash != _hashPassword(password)) {
      throw Exception('Invalid email or password.');
    }

    _setSession(user.id);
    _authChanges.add(user);
    return user;
  }

  Future<AppUser?> refresh() async {
    final user = currentUser;
    _authChanges.add(user);
    return user;
  }

  Future<void> logout() async {
    _setSession(0);
    _authChanges.add(null);
  }

  void _setSession(int userId) {
    final session = _session..userId = userId;
    _sessions.put(session);
  }

  AppUser? _findByEmail(String email) {
    final query = _users.query(AppUser_.email.equals(email)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }

  AppUser? _findByUsername(String username) {
    final query = _users.query(AppUser_.username.equals(username)).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
