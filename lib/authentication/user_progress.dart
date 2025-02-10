import 'package:eye/main.dart';

class UserProgress extends Model {
  int quizzes = 0;
  double best = 0;
  int totalScore = 0;
  int totalQuestionsAttempted = 0;
  double get averagePerQuiz => totalScore / quizzes;
  DateTime? lastQuizDate;

  UserProgress();

  UserProgress.fromJson(json) {
    id = json['id'] ?? '';
    quizzes = json['quizzes'] ?? 0;
    best = json['bestScore'] ?? 0.0;
    totalScore = json['totalScore'] ?? 0;
    totalQuestionsAttempted = json['totalQuestionsAttempted'] ?? 0;
    lastQuizDate = DateTime.fromMicrosecondsSinceEpoch(
      json['lastQuizDate'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizzes': quizzes,
      'bestScore': best,
      'totalScore': totalScore,
      'totalQuestionsAttempted': totalQuestionsAttempted,
      'lastQuizDate': lastQuizDate?.microsecondsSinceEpoch,
    };
  }

  UserProgress.none() {
    id = '';
  }
}
