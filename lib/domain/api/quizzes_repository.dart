import 'package:eye/domain/models/quiz.dart';
import 'package:eye/main.dart';

final quizzesRepository = QuizzesRepository();

class QuizzesRepository extends CRUD<Quiz> {}
