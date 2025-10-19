import 'package:eye/domain/api/quizzes_repository.dart';
import 'package:eye/domain/models/quiz.dart';
import 'package:eye/features/quizzes/quiz/quiz_page.dart';
import 'package:eye/features/quizzes/quizzes_page.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/api.dart';

final quizzesRM = RM.injectStream(
  quizzesRepository.watch,
  initialState: quizzesRepository(),
);

List<Quiz> get quizzes => quizzesRM.state;

class QuizzesTile extends UI with FTileMixin {
  @override
  Widget build(BuildContext context) {
    if (development)
      return Column(
        children: [
          'Quizzes'.text(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: quizzes.map(
                (quiz) {
                  return QuizCard(
                    title: quiz.title,
                    questionCount: 10,
                    onPressed: () {},
                  ).pad(all: 4);
                },
              ).toList(),
            ),
          ),
        ],
      );
    return FTile(
      prefixIcon: Icon(FIcons.list), // Icon for Quizzes
      // title: const Text('Quizzes'),
      title: quizzes.isEmpty
          ? 'No quizzes sorry'.text()
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: quizzes.map(
                  (quiz) {
                    return QuizCard(
                      title: quiz.title,
                      questionCount: quiz.questions.length,
                      onPressed: () => navigator.to(QuizPage(quiz: quiz)),
                    ).pad(all: 4);
                  },
                ).toList(),
              ),
            ),
      onPress: () {
        navigator.to(QuizzesPage());
      },
    );
  }
}

bool get development => false;

class QuizCard extends UI {
  final String title;
  final int questionCount;
  final VoidCallback? onPressed;

  const QuizCard({
    this.title = '',
    this.questionCount = 0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FTappable(
      onPress: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("$questionCount questions", style: TextStyle(fontSize: 14)),
          SizedBox(height: 12),
          FButton(onPress: onPressed, child: Text("Let's go!")),
        ],
      ),
    ).pad(horizontal: 8);
  }
}
