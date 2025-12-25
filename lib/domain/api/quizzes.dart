import 'package:eye/utils/object_box.dart';
import 'package:eye/domain/models/quiz.dart';

final quizzes = Quizzes();

class Quizzes with ObjectBox<Quiz> {}

final quizAttempts = QuizAttempts();

class QuizAttempts with ObjectBox<QuizAttempt> {}
