import '../../main.dart';
import '../user_progress.dart';

class UsersRepository extends Collection<AppUser> {
  UsersRepository() : super(fromJson: AppUser.fromjson);

  AppUser? getByEmail(String email) {
    final user = getAll().where((user) => user.email == email).firstOrNull;
    print("getByEmail|$email||$user");
    return user;
  }

  bool authenticated(String email, String password) {
    final user = getByEmail(email);
    final result = user != null && user.password == password;
    print('authenticated|$email|$password||$result');
    return result;
  }

  bool isEmailExists(String email) {
    final result = getByEmail(email) != null;
    print('isEmailExists|$email||$result');
    return result;
  }

  /// Authentication
  final currentIdRM = RM.inject<String>(() => '');
  void setCurrentUser(AppUser user) {
    put(user);
    currentIdRM.state = user.id;
  }

  AppUser get currentUser => get(currentIdRM.state) ?? AppUser.logout();

  bool get isUserAuthenticated {
    return currentUser.id != '';
  }

  void setUserProgress(UserProgress progress) {
    setCurrentUser(currentUser..progress = progress);
  }
}

class AppUser extends Model {
  String name = '';
  String email = '';
  String password = '';
  String _progress = '';

  int subscriptionIndex = 0;
  int themeModeIndex = 0;

  UserProgress get progress {
    try {
      return UserProgress.fromJson(jsonDecode(_progress));
    } catch (e) {
      return UserProgress.none();
    }
  }

  set progress(UserProgress value) {
    _progress = jsonEncode(value.toJson());
  }

  SubscriptionType get type => SubscriptionType.values[subscriptionIndex];
  set type(SubscriptionType value) => subscriptionIndex = value.index;

  ThemeMode get themeMode => ThemeMode.values[themeModeIndex];
  set themeMode(ThemeMode value) => themeModeIndex = value.index;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      '_progress': _progress,
      'subscriptionIndex': subscriptionIndex,
      'themeModeIndex': themeModeIndex,
      'name': name,
    };
  }

  AppUser();
  AppUser.logout() {
    id = '';
  }
  AppUser.fromjson(json) {
    name = json['name'] ?? '';
    subscriptionIndex = json['subscriptionIndex'] ?? 0;
    themeModeIndex = json['themeModeIndex'] ?? 0;
    _progress = json['_progress'] ?? '';
    password = json['password'] ?? '';
    email = json['email'] ?? '';
    id = json['id'] ?? '';
  }
}

enum SubscriptionType {
  free,
  basic,
  premium,
}

extension SubscriptionTypeX on SubscriptionType {
  String get displayName {
    switch (this) {
      case SubscriptionType.free:
        return 'Free';
      case SubscriptionType.basic:
        return 'Basic';
      case SubscriptionType.premium:
        return 'Premium';
    }
  }

  String get description {
    switch (this) {
      case SubscriptionType.free:
        return 'Limited access to quizzes';
      case SubscriptionType.basic:
        return 'Full access to quizzes';
      case SubscriptionType.premium:
        return 'Full access to quizzes and advanced features';
    }
  }

  double get price {
    switch (this) {
      case SubscriptionType.free:
        return 0;
      case SubscriptionType.basic:
        return 9.99;
      case SubscriptionType.premium:
        return 19.99;
    }
  }
}
