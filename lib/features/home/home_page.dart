import 'package:eye/domain/models/app_user.dart';
import 'package:eye/features/categories/categories.dart';
import 'package:eye/features/home/quizzes_tile.dart';
import 'package:eye/features/questions_page.dart';
import 'package:eye/features/settings_page.dart';
import 'package:eye/main.dart';

import '../../domain/models/user_progress.dart';
import '../../utils/api.dart';

mixin class DashboardBloc {
  AppUser get user =>
      //  usersRepository.one(userRepository.id) ??
      AppUser();
  String get name => user.name;

  UserProgress get progress {
    return user.progress.target ?? UserProgress();
  }
}

class HomePage extends UI with DashboardBloc {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: const Text('EYE'),
        suffixes: [
          FButton.icon(
            child: Icon(FIcons.settings),
            onPress: () {
              navigator.to(SettingsPage());
            },
          ),
        ],
      ),
      child: ListView(
        children: [
          FTileGroup.merge(
            // label: Text(name),
            label: const Text('Howdy....!'),
            divider: FTileDivider.full,
            children: [
              FTileGroup(
                divider: FTileDivider.full,
                children: [
                  FTile(
                    prefixIcon: Icon(FIcons.play), // Icon for Demo Quiz
                    title: const Text('Demo Quiz'),
                    subtitle: const Text('Take a quick demonstration quiz'),
                    onPress: () {
                      // Navigate to Demo Quiz page
                      // navigator.to(QuizTakingPage());
                    },
                  ),
                  FTile(
                    prefixIcon: Icon(FIcons.fileQuestion),
                    title: const Text('Questions'),
                    subtitle: const Text('Browse and manage questions'),
                    onPress: () {
                      // Navigate to Questions page
                      navigator.to(QuestionsPage());
                    },
                  ),
                  QuizzesTile(),
                  FTile(
                    prefixIcon: Icon(FIcons.folder), // Icon for Categories
                    title: const Text('Categories'),
                    subtitle: const Text('View quiz categories'),
                    onPress: () {
                      // Navigate to Categories page
                      navigator.to(CategoriesPage());
                    },
                  ),
                ],
              ),
              FTileGroup(
                divider: FTileDivider.full,
                children: [
                  FTile(title: Text('User Progress')),
                  FTile(
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
                  FTile(
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: FButton.icon(
                        onPress: () {
                          navigator.to(
                            SettingsPage(),
                          );
                        },
                        child: Icon(FIcons.info),
                      ),
                    ),
                  ),
                ],
              ),
              FTileGroup(
                label: const Text('Explore Features'),
                divider: FTileDivider.full,
                children: [
                  // Add the four buttons here
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
