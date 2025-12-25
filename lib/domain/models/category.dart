import 'package:manager/manager.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Category extends Model {
  @Id(assignable: true)
  int id = 0;
  String name = '';
}
