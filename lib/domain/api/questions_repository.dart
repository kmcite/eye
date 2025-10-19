import 'package:eye/domain/models/question.dart';
import 'package:eye/main.dart';

final questionsRepository = QuestionsRepository();

class QuestionsRepository extends CRUD<Question> {}
