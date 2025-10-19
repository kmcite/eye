import 'package:eye/domain/api/questions_repository.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/domain/models/quiz.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/api.dart';

// Iterable<Question> get totalQuestions => questionsRepository.getAll();

// final questionsRM = RM.inject(() => <Question>[]);
// Iterable<Question> get selectedQuestions => questionsRM.state;

void add(Question value) {
  selectedQuestions(selectedQuestions()..add(value));
}

void remove(Question value) {
  selectedQuestions(
    selectedQuestions().where((question) => question.id != value.id).toList(),
  );
}

Quiz quiz([Quiz? value]) {
  throw '';
}

void save() {
  // quizzesRepository(
  //   quiz()..questions = [...quiz().questions, ...selectedQuestions],
  // );
  navigator.back();
}

final selectedQuestionsRM = <Question>[].inj();
List<Question> selectedQuestions([List<Question>? value]) {
  if (value != null) {
    selectedQuestionsRM
      ..state = value
      ..notify();
  }
  return selectedQuestionsRM.state;
}

List<Question> get allQuestions => questionsRepository();
bool contains(Question value) {
  return selectedQuestions().any((question) => question.id == value.id);
}

class QuestionSelectorDialog extends UI {
  Widget build(BuildContext context) {
    return FDialog(
      body: allQuestions.isEmpty
          ? 'NO QUESTIONS'.text()
          : FTileGroup.builder(
              label: 'Select questions to add'.text(),
              count: allQuestions.length,
              tileBuilder: (BuildContext context, int index) {
                final question = allQuestions.elementAt(index);
                return OnReactive(
                  () => FTile(
                    title: question.statement.text(),
                    onPress: () {
                      if (contains(question))
                        remove(question);
                      else
                        add(question);
                    },
                    suffixIcon: contains(question) ? Icon(FIcons.check) : null,
                  ),
                );
              },
            ),
      actions: [
        FButton(
          child: Icon(FIcons.arrowLeft),
          onPress: () {
            navigator.back();
          },
        ),
        FButton(
          child: Icon(FIcons.save),
          onPress: allQuestions.isEmpty ? null : () => save(),
        ),
      ],
      direction: Axis.horizontal,
    );
  }
}
