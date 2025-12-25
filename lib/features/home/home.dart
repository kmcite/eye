import 'package:eye/domain/api/quizzes.dart';
import 'package:eye/domain/api/users.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/features/categories/categories.dart';
import 'package:eye/domain/models/user_progress.dart';
import 'package:eye/features/home/app_drawer.dart';
import 'package:eye/features/home/quizzes_tile.dart';
import 'package:eye/features/questions_page.dart';
import 'package:eye/features/quizzes/quiz_taking.dart';
import 'package:eye/features/settings_page.dart';
import 'package:eye/features/user/user_profile.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';
import 'package:manager/manager.dart';

extension on HomePage {
  AppUser? get user => safeUser;

  UserProgress get progress {
    return user?.progress.target ?? UserProgress();
  }
}

class HomePage extends UI {
  static const route = "/";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('EYE'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              router.to(SettingsPage.route);
            },
          ),
          SizedBox(width: 8),
        ],
      ),

      body:
          // AppDrawer(),
          homeBody(),
    );
  }

  ListView homeBody() {
    return ListView(
      children: [
        Column(
          children: [
            ListTile(
              title: const Text('Howdy...!'),
            ),
            ListTile(
              leading: Icon(Icons.play_arrow), // Icon for Demo Quiz
              title: const Text('Demo Quiz'),
              subtitle: const Text('Take a quick demonstration quiz'),
              onTap: () {
                router.to(
                  QuizTakingPage.route,
                  // TODO just for demo purposes
                  arguments: quizzes.state.first,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.file_copy), // Icon for Demo Quiz
              title: const Text('Questions'),
              subtitle: const Text('Browse and manage questions'),
              onTap: () {
                // Navigate to Questions page
                router.to(QuestionsPage.route);
              },
            ),

            QuizzesTile(),
            ListTile(
              leading: Icon(Icons.folder), // Icon for Categories
              title: const Text('Categories'),
              subtitle: const Text('View quiz categories'),
              onTap: () {
                // Navigate to Categories page
                router.to(CategoriesPage.route);
              },
            ),
            ListTile(title: Text('User Progress')),
            ListTile(
              title: const Text('Best Score'),
              subtitle: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: progress.best,
                          strokeWidth: 8.0,
                        ).pad(),
                      ),
                      Text(
                        '${(progress.best * 100).toStringAsFixed(0)}%',
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quizzes Taken: ${progress.quizzes}'),
                      Text(
                        'Total Questions: ${progress.totalQuestionsAttempted}',
                      ),
                      // Text(
                      //   'Average Score: ${progress.averagePerQuiz.toStringAsFixed(1)}',
                      // ),
                      // Text(
                      //   'Last Quiz: ${progress.lastQuizDate?.toLocal().toString().split(' ')[0] ?? "N/A"}',
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => router.to(UserProfilePage.route),
                  child: Icon(Icons.info),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
