import 'package:eye/main.dart';

import '../questions/questions_repository.dart';

final quizzesRepository = QuizzesRepository();

class QuizzesRepository extends Collection<Quiz> {
  QuizzesRepository() : super(fromJson: Quiz.fromJson);
  final quizRM = RM.inject<Quiz>(() => throw UnimplementedError());
  Quiz get quiz => quizRM.state;
  set quiz(Quiz value) {
    quizRM
      ..state = value
      ..notify();
  }
}

class Quiz extends Model {
  String title = '';
  String _questions = '';
  Iterable<Question> get questions {
    try {
      return (jsonDecode(_questions) as List<dynamic>).map(
        (json) {
          return Question.fromJson(json as Map<String, dynamic>);
        },
      ).toList();
    } catch (e) {
      return [];
    }
  }

  set questions(Iterable<Question> value) {
    _questions = jsonEncode(
      value.toList().map((question) => question.toJson()).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      '_questions': _questions,
    };
  }

  Quiz();
  Quiz.fromJson(json) {
    id = json['id'] ?? '';
    title = json['title'] ?? '';
    _questions = json['_questions'] ?? '';
  }

  Quiz.none() {
    id = '';
  }
}
