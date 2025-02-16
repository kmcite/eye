import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:eye/questions/questions_repository.dart';
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
          _quiz.quiz.id.text(textScaleFactor: .9),
          (_quiz.quiz.questions).isEmpty
              ? 'No questions'.text(textScaleFactor: 3).pad().center()
              : FTileGroup.builder(
                  count: _quiz.quiz.questions.length,
                  tileBuilder: (context, index) {
                    final question = _quiz.quiz.questions.elementAt(index);
                    return FTile(
                      onPress: () {},
                      title: question.statement.text(),
                    );
                  },
                ),
          FTextField(
            initialValue: _quiz.title(),
            onChange: _quiz.title,
          ).pad(),
          FButton(
            onPress: () => _quiz.to(QuestionSelectorDialog()),
            label: 'Add'.text(),
          ).pad(),
        ],
      ),
    );
  }
}

final questionsSelector = QuestionsSelector();

class QuestionsSelector extends Bloc {
  Iterable<Question> get totalQuestions => questionsRepository.getAll();

  final questionsRM = RM.inject(() => <Question>[]);
  Iterable<Question> get selectedQuestions => questionsRM.state;

  bool selected(Question value) {
    return selectedQuestions.any((question) => question.id == value.id);
  }

  void add(Question value) {
    questionsRM
      ..state = [...selectedQuestions, value]
      ..notify();
  }

  void remove(Question value) {
    questionsRM
      ..state = selectedQuestions.where(
        (question) {
          return question.id != value.id;
        },
      ).toList()
      ..notify();
    ;
  }

  Quiz get quiz => quizzesRepository.quiz;
  void save() {
    quizzesRepository.quiz = quiz
      ..questions = [
        ...quiz.questions,
        ...selectedQuestions,
      ];
    back();
  }
}

class QuestionSelectorDialog extends UI {
  Widget build(BuildContext context) {
    return FDialog(
      // title: 'Select'.text(),
      body: FTileGroup.builder(
        label: 'Select questions to add'.text(),
        count: questionsSelector.totalQuestions.length,
        tileBuilder: (BuildContext context, int index) {
          final question = questionsSelector.totalQuestions.elementAt(index);
          return OnReactive(
            () => FTile(
              title: question.statement.text(),
              onPress: () {
                if (questionsSelector.selected(question))
                  questionsSelector.remove(question);
                else
                  questionsSelector.add(question);
              },
              suffixIcon: questionsSelector.selected(question)
                  ? FIcon(FAssets.icons.check)
                  : null,
            ),
          );
        },
      ),
      actions: [
        FButton(
          label: FIcon(FAssets.icons.arrowLeft),
          onPress: () {
            questionsSelector.back();
          },
        ),
        FButton(
          label: FIcon(FAssets.icons.save),
          onPress: () {
            questionsSelector.save();
          },
        ),
      ],
      direction: Axis.horizontal,
    );
  }
}
