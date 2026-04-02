import 'package:eye/business/users.dart';
import 'package:eye/domain/api/quizzes.dart';
import 'package:eye/features/categories/categories.dart';
import 'package:eye/features/home/app_drawer.dart';
import 'package:eye/features/home/quizzes_tile.dart';
import 'package:eye/features/questions_page.dart';
import 'package:eye/features/quizzes/quiz_taking.dart';
import 'package:eye/features/settings_page.dart';
import 'package:eye/features/user/user_profile.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/navigator.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Greeting section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Howdy...!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Quick Access Section
        ListTile(
          leading: Icon(Icons.play_arrow),
          title: const Text('Demo Quiz'),
          subtitle: const Text('Take a quick demonstration quiz'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            router.to(
              QuizTakingPage.route,
              arguments: quizzes().first,
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.file_copy),
          title: const Text('Questions'),
          subtitle: const Text('Browse and manage questions'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            router.to(QuestionsPage.route);
          },
        ),
        QuizzesTile(),
        ListTile(
          leading: Icon(Icons.folder),
          title: const Text('Categories'),
          subtitle: const Text('View quiz categories'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            router.to(CategoriesPage.route);
          },
        ),
        // Progress Section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Your Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: userProgress()?.best,
                          strokeWidth: 8.0,
                        ),
                      ),
                      Text(
                        '${(userProgress()!.best * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Text(
                          'Best Score',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Quizzes: ${userProgress()!.quizzes}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Questions: ${userProgress()!.totalQuestionsAttempted}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Profile Action Section
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () => router.to(UserProfilePage.route),
            icon: Icon(Icons.person),
            label: const Text('View Profile'),
          ),
        ),
      ],
    );
  }
}
