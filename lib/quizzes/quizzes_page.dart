import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

import 'quiz_page.dart';
import 'quizzes_repository.dart';

final _quizzes = QuizzesBloc();

class QuizzesBloc extends Bloc {
  Iterable<Quiz> get quizzes => quizzesRepository.getAll();
  void put(Quiz quiz) => quizzesRepository.put(quiz);
  late var back = navigation.back;

  void toQuizPage(Quiz quiz) {
    quizzesRepository.quiz = quiz;
    navigation.to(QuizPage());
  }
}

class QuizzesPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [
          FHeaderAction.back(onPress: _quizzes.back),
        ],
        title: 'Quizzes'.text(),
      ),
      content: Column(
        children: [
          FTextField(
            label: 'Search quizzes by name'.text(),
          ).pad(),
          FTileGroup.builder(
            divider: FTileDivider.full,
            count: _quizzes.quizzes.length,
            tileBuilder: (context, index) {
              final quiz = _quizzes.quizzes.elementAt(index);
              return FTile(
                title: quiz.title.text(),
                subtitle: quiz.id.text(),
                onPress: () => _quizzes.toQuizPage(quiz),
              );
            },
          ),
        ],
      ),
      footer: FButton(
        onPress: () {
          _quizzes.put(Quiz());
        },
        label: 'Add quiz'.text(),
        suffix: Icon(Icons.add),
      ).pad(),
    );
  }
}
