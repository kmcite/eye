import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

@Entity()
class Category {
  Category({
    this.id = 0,
    String? syncKey,
    required this.name,
    DateTime? created,
    DateTime? updated,
  })  : syncKey = syncKey ?? const Uuid().v4(),
        created = created ?? DateTime.now().toUtc(),
        updated = updated ?? DateTime.now().toUtc();

  @Id()
  int id;

  @Unique()
  String syncKey;

  String name;

  @Property(type: PropertyType.dateUtc)
  DateTime created;

  @Property(type: PropertyType.dateUtc)
  DateTime updated;
}
