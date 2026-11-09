import 'package:objectbox/objectbox.dart';

@Entity()
class SyncAppliedRemote {
  SyncAppliedRemote({
    this.id = 0,
    required this.remoteId,
    DateTime? appliedAt,
  }) : appliedAt = appliedAt ?? DateTime.now().toUtc();

  @Id()
  int id;

  @Unique()
  String remoteId;

  @Property(type: PropertyType.dateUtc)
  DateTime appliedAt;
}
