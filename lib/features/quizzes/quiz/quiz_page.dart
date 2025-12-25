import 'package:eye/domain/api/questions.dart';
import 'package:eye/domain/api/quizzes.dart';
import 'package:eye/domain/models/quiz.dart';
import 'package:eye/features/quizzes/quiz/question_selector_dialog.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';
import 'package:manager/extensions.dart';

final quizRM = RM.inject<Quiz?>(() => null);

class QuizPage extends UI {
  static const route = '/quiz';

  const QuizPage({super.key});
  @override
  void didMountWidget(BuildContext context) {
    super.didMountWidget(context);
    quizRM.state = context.routeData.arguments as Quiz;
  }

  void didUnmountWidget() {
    quizRM.state = null;
    super.didUnmountWidget();
  }

  Quiz get quiz => quizRM.state!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => router.toDialog(
              QuestionSelectorDialog(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              quizzes.remove(quiz.id);
              router.back();
            },
          ),
        ],
        title: quiz.title.text(),
      ),
      body: Column(
        children: [
          quiz.id.text(textScaleFactor: .9),
          quiz.questions.isEmpty
              ? 'No questions'.text(textScaleFactor: 3).pad().center()
              : Expanded(
                  child: ListView.builder(
                    itemCount: quiz.questions.length,
                    itemBuilder: (context, index) {
                      final questionId = quiz.questions.elementAt(index);
                      final question = questions.getById(questionId);
                      if (question == null) {
                        return SizedBox.shrink();
                      }
                      return ListTile(
                        title: question.statement.text(),
                      );
                    },
                  ),
                ),
          TextFormField(
            initialValue: quiz.title,
            onChanged: (value) => quiz.title = value,
          ).pad(),
          Spacer(),
          ElevatedButton(
            onPressed: () => router.toDialog(QuestionSelectorDialog()),
            child: 'Add Questions'.text(),
          ),
        ],
      ),
    );
  }
}
