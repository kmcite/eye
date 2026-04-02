import 'package:eye/domain/models/quiz.dart';
import 'package:eye/features/quizzes/quiz/quiz_page.dart';
import 'package:eye/features/quizzes/quiz_card.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';
import 'package:eye/utils/navigator.dart';

import '../../domain/api/quizzes.dart';

final searchQuizzesField = signal('');

final searchedQuizzes = computed(() {
  if (searchQuizzesField().isEmpty) {
    return quizzes();
  } else {
    return quizzes()
        .where(
          (quiz) => quiz.title.toLowerCase().contains(
            searchQuizzesField().toLowerCase(),
          ),
        )
        .toList();
  }
});

class QuizzesPage extends UI {
  static String route = "/quizzes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              put(Quiz());
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Field with improved styling
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: searchQuizzesField(),
              onChanged: searchQuizzesField,
              decoration: InputDecoration(
                labelText: 'Search quizzes...',
                hintText: 'Search by quiz name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: searchedQuizzes().isEmpty
                ? QuizEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: searchedQuizzes().length,
                    itemBuilder: (context, index) {
                      final quiz = searchedQuizzes().elementAt(index);
                      return QuizCard(
                        quiz: quiz,
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
