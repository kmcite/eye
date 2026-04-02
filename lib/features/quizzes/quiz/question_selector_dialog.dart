import 'package:eye/domain/api/questions.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/navigator.dart';

final selectedQuestions = listSignal<Question>();

bool contains(Question value) {
  return selectedQuestions().any((question) => question.id == value.id);
}

class QuestionSelectorDialog extends UI {
  Widget build(BuildContext context) {
    return AlertDialog(
      content: questions().isEmpty
          ? Text('NO QUESTIONS')
          : ListView.builder(
              itemCount: questions().length,
              itemBuilder: (context, index) {
                final question = questions().elementAt(index);
                return OnReactive(
                  () => ListTile(
                    title: Text(question.statement),
                    trailing: contains(question) ? Icon(Icons.check) : null,
                    onTap: () {
                      if (contains(question))
                        selectedQuestions.remove(question);
                      else
                        selectedQuestions.add(question);
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
          onPressed: questions().isEmpty ? null : () => router.back(),
        ),
      ],
    );
  }
}
