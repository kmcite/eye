import 'package:eye/authentication/user_progress.dart';
import 'package:eye/main.dart';
import 'package:eye/questions/questions_page.dart';
import 'package:eye/quiz_taking/quiz_taking.dart';
import 'package:eye/quizzes/quizzes_page.dart';
import 'package:forui/forui.dart';

import '../categories/categories.dart';
import '../dependency_injection.dart';
import '../settings/settings_page.dart';

final _dashboard = DashboardBloc();

class DashboardBloc extends Bloc {
  String get name => usersRepository.currentUser.name;
  UserProgress get progress => usersRepository.currentUser.progress;
}

class DashboardPage extends UI {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Text('EYE'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FButton.icon(
              child: FIcon(FAssets.icons.settings),
              onPress: () => _dashboard.to(SettingsPage()),
            ),
          ),
        ],
      ),
      content: FTileGroup.merge(
        label: _dashboard.name.text(),
        divider: FTileDivider.full,
        children: [
          FTileGroup(
            divider: FTileDivider.full,
            children: [
              FTile(
                title: 'DEMO QUIZ'.text(),
                subtitle: FBadge(label: 'Take Quiz'.text()),
                onPress: () {
                  _dashboard.to(QuizTakingPage());
                },
              ),
              FTile(
                title: 'Questions'.text(),
                subtitle: 'Questions'.text(),
                onPress: () => _dashboard.to(QuestionsPage()),
              ),
              FTile(
                title: 'Quizzes'.text(),
                subtitle: 'Quizzes'.text(),
                onPress: () => _dashboard.to(QuizzesPage()),
              ),
              FTile(
                title: 'Categories'.text(),
                subtitle: 'Categories'.text(),
                onPress: () => _dashboard.to(CategoriesPage()),
              ),
            ],
          ),
          FTileGroup(
            label: 'User Progress'.text(),
            divider: FTileDivider.full,
            children: [
              FTile(
                title: 'Overall Performance'.text(),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'Best Score: ${(_dashboard.progress.best * 100).toStringAsFixed(0)}%'
                        .text(),
                    FProgress(value: _dashboard.progress.best).pad(),
                    'Quizzes Taken: ${_dashboard.progress.quizzes}'.text(),
                    'Total Questions: ${_dashboard.progress.totalQuestionsAttempted}'
                        .text(),
                    'Average Score: ${_dashboard.progress.averagePerQuiz.toStringAsFixed(1)}'
                        .text(),
                    'Last Quiz: ${_dashboard.progress.lastQuizDate?.toLocal().toString().split(' ')[0] ?? "N/A"}'
                        .text(),
                    FButton.icon(
                      onPress: () {
                        _dashboard.to(SettingsPage());
                      },
                      child: FIcon(FAssets.icons.info),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
