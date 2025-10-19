import 'package:objectbox/objectbox.dart';

@Entity()
class UserProgress {
  @Id()
  int id = 0;
  int quizzes = 0;
  double best = 0;
  int totalScore = 0;
  int totalQuestionsAttempted = 0;
  // double get averagePerQuiz => totalScore / quizzes;
  // DateTime lastQuizDate = DateTime.now();
}
