import 'package:eye/domain/models/app_user.dart';
// import 'package:eye/users/objectbox.dart';
import 'package:spark/spark.dart';

final usersSpark = RM.inject(() => UsersSpark());

class UsersSpark {
  var users = <AppUser>[];

  void remove(String id) {}
}
