import 'package:eye/domain/models/subscription_type.dart';
import 'package:eye/domain/models/user_progress.dart';
import 'package:eye/main.dart';
import 'package:manager/manager.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AppUser extends Model {
  @Id()
  int id = 0;
  String name = '';
  String email = '';
  String password = '';
  final progress = ToOne<UserProgress>();

  int subscriptionIndex = 0;
  @Transient()
  SubscriptionType get type => SubscriptionType.values[subscriptionIndex];
  set type(SubscriptionType value) => subscriptionIndex = value.index;

  bool dark = false;
  @Transient()
  ThemeMode get themeMode => dark ? ThemeMode.dark : ThemeMode.light;
  set themeMode(ThemeMode value) => dark = value == ThemeMode.dark;

  List<int> quizIds = [];
}
