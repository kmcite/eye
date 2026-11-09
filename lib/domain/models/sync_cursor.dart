import 'package:objectbox/objectbox.dart';

/// Singleton row (id 1): cursor for incremental pull + device id.
@Entity()
class SyncCursor {
  SyncCursor({
    this.id = 1,
    this.lastPulledCreated = '',
    this.deviceId = '',
  });

  @Id()
  int id;

  String lastPulledCreated;
  String deviceId;
}
