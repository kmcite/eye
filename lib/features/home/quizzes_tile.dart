import 'package:eye/domain/api/quizzes.dart';
import 'package:eye/features/quizzes/quizzes_page.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/navigator.dart';

class QuizzesTile extends UI {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.list),
      title: const Text('Available Quizzes'),
      subtitle: quizzes().isEmpty
          ? const Text('No quizzes available')
          : Text('${quizzes().length} quizzes available'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        router.to(QuizzesPage.route);
      },
    );
  }
}
