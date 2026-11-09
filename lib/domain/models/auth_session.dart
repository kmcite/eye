import 'package:objectbox/objectbox.dart';

/// Single-row session: ObjectBox id 1 holds the signed-in [userId], or 0.
@Entity()
class AuthSession {
  AuthSession({
    this.id = 1,
    this.userId = 0,
  });

  @Id(assignable: true)
  int id;

  int userId;
}
