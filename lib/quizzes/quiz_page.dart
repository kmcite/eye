import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:eye/quizzes/quizzes_repository.dart';
import 'package:forui/forui.dart';

final _quiz = QuizBloc();

class QuizBloc extends Bloc {
  Quiz get quiz => quizzesRepository.quiz;

  set quiz(Quiz value) {
    quizzesRepository.quiz = value;
    quizzesRepository.put(value);
  }

  String title([String? value]) {
    if (value != null) {
      quiz = quiz..title = value;
    }
    return quiz.title;
  }

  late var back = navigation.back;
}

class QuizPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [
          FHeaderAction.x(onPress: _quiz.back),
        ],
        title: _quiz.quiz.title.text(),
      ),
      content: Column(
        children: [
          _quiz.quiz.id.text(),
          (_quiz.quiz.questions).isEmpty
              ? 'No questions'.text(textScaleFactor: 3).card().pad().center()
              : FTileGroup.builder(
                  count: _quiz.quiz.questions.length,
                  tileBuilder: (context, index) {
                    final question = _quiz.quiz.questions.elementAt(index);
                    return FButton(
                      onPress: () {},
                      label: question.text(),
                    );
                  },
                ),
          FTextField(
            initialValue: _quiz.title(),
            onChange: (value) => _quiz.title(value),
          ).pad(),
        ],
      ),
    );
  }
}
