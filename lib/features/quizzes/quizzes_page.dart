import 'package:eye/domain/models/quiz.dart';
import 'package:eye/features/quizzes/quiz/quiz_page.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/api.dart';

import '../../../domain/api/quizzes_repository.dart';

List<Quiz> get quizzes => quizzesRM.state;
final quizzesRM = RM.injectStream(
  quizzesRepository.watch,
  initialState: quizzesRepository(),
);
void put(Quiz quiz) => quizzesRepository.put(quiz);
late var back = navigator.back;

void toQuizPage(Quiz quiz) {
  // quizzesRepository.item(quiz);
  navigator.to(QuizPage(quiz: quiz));
}

class QuizzesPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: navigator.back),
        ],
        title: 'Quizzes'.text(),
        suffixes: [
          FButton.icon(
            onPress: () {
              put(Quiz());
            },
            child: ' + '.text(),
          ),
        ],
      ),
      child: Column(
        children: [
          FTextField(label: 'Search quizzes by name'.text()).pad(),
          FTileGroup.builder(
            divider: FTileDivider.full,
            count: quizzes.length,
            tileBuilder: (context, index) {
              final quiz = quizzes.elementAt(index);
              return FTile(
                title: quiz.title.text(),
                subtitle: quiz.id.text(),
                onPress: () => toQuizPage(quiz),
              );
            },
          ),
        ],
      ),
    );
  }
}
