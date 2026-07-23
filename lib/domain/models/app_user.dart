import 'package:pocketbase/pocketbase.dart';

class AppUser extends Jsonable {
  final String id;
  final String email;
  final String username;
  final String name;
  final String avatar;
  final DateTime created;
  final DateTime updated;

  AppUser({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.avatar,
    required this.created,
    required this.updated,
  });

  factory AppUser.fromRecord(RecordModel record) {
    return AppUser(
      id: record.id,
      email: record.getStringValue('email'),
      username: record.getStringValue('username'),
      name: record.getStringValue('name'),
      avatar: record.getStringValue('avatar'),
      created: DateTime.parse(record.created),
      updated: DateTime.parse(record.updated),
    );
  }

  /// Construct from a standard Map
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      username: map['username'] as String? ?? '',
      name: map['name'] as String? ?? '',
      avatar: map['avatar'] as String? ?? '',
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
    );
  }

  /// Converts the model instance to a JSON-compatible Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'avatar': avatar,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}
