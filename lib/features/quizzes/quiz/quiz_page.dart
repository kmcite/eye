import 'package:eye/domain/api/quizzes_repository.dart';
import 'package:eye/domain/models/quiz.dart';
import 'package:eye/features/quizzes/quiz/question_selector_dialog.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/api.dart';

void _put(Quiz quiz) => quizzesRepository.put(quiz);
void _remove(int id) {
  quizzesRepository.remove(id);
  navigator.back();
}

class QuizPage extends UI {
  final Quiz quiz;
  QuizPage({super.key, required this.quiz});
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.x(onPress: navigator.back),
          FHeaderAction(
            icon: Icon(FIcons.plus),
            onPress: () => navigator.toDialog(
              QuestionSelectorDialog(),
            ),
          ),
        ],
        suffixes: [
          FButton.icon(
            onPress: () => _remove(quiz.id),
            child: Icon(FIcons.delete),
          )
        ],
        title: quiz.title.text(),
      ),
      child: Column(
        children: [
          quiz.id.text(textScaleFactor: .9),
          (quiz.questions).isEmpty
              ? 'No questions'.text(textScaleFactor: 3).pad().center()
              : FTileGroup.builder(
                  count: quiz.questions.length,
                  tileBuilder: (context, index) {
                    final question = quiz.questions.elementAt(index);
                    return FTile(
                      onPress: () {},
                      title: question.statement.text(),
                    );
                  },
                ),
          FTextField(
            initialText: quiz.title,
            onChange: (value) {
              _put(quiz..title = value);
            },
          ).pad(),
          Spacer(),
          FButton(
            onPress: () => navigator.toDialog(QuestionSelectorDialog()),
            child: 'Add Questions'.text(),
          ).pad(),
        ],
      ),
    );
  }
}
