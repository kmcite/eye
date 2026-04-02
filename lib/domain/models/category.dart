import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  @Id(assignable: true)
  int id = 0;
  String name = '';
}
