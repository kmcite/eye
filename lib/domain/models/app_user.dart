import 'package:objectbox/objectbox.dart';

@Entity()
class AppUser {
  AppUser({
    this.id = 0,
    required this.email,
    required this.username,
    this.name = '',
    this.avatar = '',
    this.passwordHash = '',
    DateTime? created,
    DateTime? updated,
  }) : created = created ?? DateTime.now(),
       updated = updated ?? DateTime.now();

  @Id()
  int id;

  @Unique()
  String email;

  @Unique()
  String username;

  String name;
  String avatar;
  String passwordHash;

  @Property(type: PropertyType.dateUtc)
  DateTime created;

  @Property(type: PropertyType.dateUtc)
  DateTime updated;

  AppUser copyWith({
    int? id,
    String? email,
    String? username,
    String? name,
    String? avatar,
    String? passwordHash,
    DateTime? created,
    DateTime? updated,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      passwordHash: passwordHash ?? this.passwordHash,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }
}
