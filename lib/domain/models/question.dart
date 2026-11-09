import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

@Entity()
class Question {
  Question({
    this.id = 0,
    String? syncKey,
    required this.statement,
    List<String>? options,
    required this.correctIndex,
    this.explanation = '',
    this.categoryId = 0,
    DateTime? created,
    DateTime? updated,
    String? optionsJson,
  })  : syncKey = syncKey ?? const Uuid().v4(),
        optionsJson = optionsJson ?? jsonEncode(options ?? const []),
        created = created ?? DateTime.now().toUtc(),
        updated = updated ?? DateTime.now().toUtc();

  @Id()
  int id;

  @Unique()
  String syncKey;

  String statement;
  String optionsJson;
  int correctIndex;
  String explanation;

  /// Local [Category.id]; `0` = uncategorized.
  int categoryId;

  @Property(type: PropertyType.dateUtc)
  DateTime created;

  @Property(type: PropertyType.dateUtc)
  DateTime updated;

  List<String> get options {
    final decoded = jsonDecode(optionsJson);
    if (decoded is! List) return const [];
    return decoded.map((e) => e.toString()).toList();
  }

  set options(List<String> value) {
    optionsJson = jsonEncode(value);
  }
}
