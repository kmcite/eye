import 'package:objectbox/objectbox.dart';

@Entity()
class SyncOutboxEntry {
  SyncOutboxEntry({
    this.id = 0,
    required this.entityType,
    required this.operation,
    required this.entityKey,
    required this.payloadJson,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc();

  @Id()
  int id;

  String entityType;
  String operation;
  String entityKey;
  String payloadJson;

  @Property(type: PropertyType.dateUtc)
  DateTime createdAt;
}
