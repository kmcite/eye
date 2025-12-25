import 'package:eye/domain/models/quiz.dart';
import 'package:eye/features/quizzes/quiz/quiz_page.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';
import 'package:manager/manager.dart';

import '../../domain/api/quizzes.dart';

final searchQuizzesField = RM.injectTextEditing();

List<Quiz> get searchedQuizzes {
  if (searchQuizzesField.text.isEmpty) {
    return quizzes.state;
  } else {
    return quizzes.state
        .where((quiz) => quiz.title.contains(searchQuizzesField.text))
        .toList();
  }
}

class QuizzesPage extends UI {
  static String route = "/quizzes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Quizzes'.text(),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              quizzes.put(Quiz());
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: searchQuizzesField.controller,
            decoration: InputDecoration(labelText: 'Search quizzes by name'),
          ).pad(),
          Expanded(
            child: ListView.builder(
              itemCount: searchedQuizzes.length,
              itemBuilder: (context, index) {
                final quiz = searchedQuizzes.elementAt(index);
                return ListTile(
                  title: quiz.title.text(),
                  subtitle: quiz.id.text(),
                  onTap: () {
                    router.to(QuizPage.route, arguments: quiz);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
