import 'package:eye/domain/api/questions.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/domain/models/quiz.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';
import 'package:manager/extensions.dart';

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
  router.back();
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

List<Question> get allQuestions => questions();
bool contains(Question value) {
  return selectedQuestions().any((question) => question.id == value.id);
}

class QuestionSelectorDialog extends UI {
  Widget build(BuildContext context) {
    return AlertDialog(
      content: allQuestions.isEmpty
          ? 'NO QUESTIONS'.text()
          : ListView.builder(
              itemCount: allQuestions.length,
              itemBuilder: (context, index) {
                final question = allQuestions.elementAt(index);
                return OnReactive(
                  () => ListTile(
                    title: question.statement.text(),
                    trailing: contains(question) ? Icon(Icons.check) : null,
                    onTap: () {
                      if (contains(question))
                        remove(question);
                      else
                        add(question);
                    },
                  ),
                );
              },
            ),
      actions: [
        ElevatedButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            router.back();
          },
        ),
        ElevatedButton(
          child: Icon(Icons.save),
          onPressed: allQuestions.isEmpty ? null : () => save(),
        ),
      ],
    );
  }
}
