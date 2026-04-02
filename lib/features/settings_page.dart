import 'package:eye/business/users.dart';
import 'package:eye/domain/api/questions.dart';
import 'package:eye/domain/api/quizzes.dart';
import 'package:eye/domain/models/quiz.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';
import 'package:eye/utils/navigator.dart';

class SettingsPage extends UI {
  static const route = '/settings';

  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              dark().choose(
                Icons.dark_mode,
                Icons.light_mode,
                Icons.system_update,
              ),
            ),
            title: Text('Theme'),
            subtitle: Text(
              dark().choose('Dark mode', 'Light mode', 'System mode'),
            ),
            onTap: () {
              final u = user();
              if (u != null) {
                put(u..dark = !u.dark);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.quiz),
            title: Text('My Quizzes'),
            subtitle: user()!.quizIds.isEmpty
                ? Text('No quizzes created')
                : Text('${user()!.quizIds.length} quizzes'),
            trailing: ElevatedButton(
              onPressed: () {
                router.toDialog(CreateQuizDialog());
              },
              child: Icon(Icons.question_answer),
            ),
          ),
          if (user()!.quizIds.isNotEmpty) ...[
            ListTile(
              title: Text('Quiz List'),
              subtitle: Column(
                children: user()!.quizIds.map(
                  (id) {
                    final quiz = quizzes().firstWhere((e) => e.id == id);
                    return ListTile(
                      title: Text(quiz.title),
                      dense: true,
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final selectedQuestionsRM = RM.inject(() => <int>[]);
final quizNameField = RM.injectTextEditing();

class CreateQuizDialog extends UI {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create New Quiz'),
      content: Column(
        mainAxisSize: .min,
        mainAxisAlignment: .start,
        spacing: 8,
        children: [
          TextFormField(
            controller: quizNameField.controller,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: questions().length,
            itemBuilder: (context, index) {
              final question = questions()[index];
              return OnReactive(
                () => CheckboxListTile(
                  title: Text(question.statement),
                  value: selectedQuestionsRM.state.contains(question.id),
                  onChanged: (bool? selected) {
                    if (selected!) {
                      selectedQuestionsRM.state = [
                        ...selectedQuestionsRM.state,
                        question.id,
                      ];
                    } else {
                      selectedQuestionsRM.state = List.from(
                        selectedQuestionsRM.state,
                      )..remove(question.id);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            router.back();
          },
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: (selectedQuestionsRM.state.isEmpty)
              ? null
              : () async {
                  final quizId = await put(
                    Quiz()
                      ..questions = selectedQuestionsRM.state
                      ..title = quizNameField.text
                      ..userId = user()!.id,
                  );
                  put(user()!..quizIds.add(quizId));
                  router.back();
                },
          child: Text('Create'),
        ),
      ],
    );
  }
}
