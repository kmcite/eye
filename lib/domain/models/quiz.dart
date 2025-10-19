import 'package:eye/domain/models/question.dart';
import 'package:eye/main.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Quiz extends Model {
  @Id()
  int id = 0;
  String title = '';
  final questions = ToMany<Question>();
}
