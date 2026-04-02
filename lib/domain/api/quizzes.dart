import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';
import 'package:eye/domain/models/quiz.dart';

final quizzes = listSignal(getAll<Quiz>());
final quizAttempts = listSignal(getAll<QuizAttempt>());
