import 'package:manager/manager.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Quiz extends Model {
  @Id()
  int id = 0;
  String title = '';
  List<int> questions = [];
  int? userId; // owner
}

@Entity()
class QuizAttempt extends Model {
  @Id()
  int id = 0;
  int? userId; // if null no associated user [AppUser]
  int? quizId; // if null no associated quiz [Quiz]
  DateTime startedAt = DateTime.now();
  DateTime? endedAt; // if null not ended yet

  int total = 0;
  int correct = 0;

  double get accuracy => total == 0 ? 0 : correct / total * 100;
}
