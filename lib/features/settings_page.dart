import 'package:eye/domain/api/questions.dart';
import 'package:eye/domain/api/quizzes.dart';
import 'package:eye/domain/api/users.dart';
import 'package:eye/domain/models/quiz.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';
import 'package:manager/extensions.dart';
import 'package:yaru/yaru.dart';

class SettingsPage extends UI {
  static const route = '/settings';

  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Settings'.text(),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: users.loading
                ? YaruCircularProgressIndicator()
                : Icon(
                    switch (safeDark) {
                      false => Icons.light_mode,
                      true => Icons.dark_mode,
                    },
                  ),
            title: Text('Theme'),
            subtitle: Text(safeDark ? 'Dark mode' : 'Light mode'),
            onTap: users.loading
                ? null
                : () {
                    if (safeUser != null) {
                      users.put(safeUser!..dark = !safeDark);
                    }
                  },
          ),
          ListTile(
            leading: Icon(Icons.quiz),
            title: Text('My Quizzes'),
            subtitle: safeUser!.quizIds.isEmpty
                ? Text('No quizzes created')
                : Text('${safeUser!.quizIds.length} quizzes'),
            trailing: ElevatedButton(
              onPressed: () {
                router.toDialog(CreateQuizDialog());
              },
              child: Icon(Icons.question_answer),
            ),
          ),
          if (safeUser!.quizIds.isNotEmpty) ...[
            ListTile(
              title: Text('Quiz List'),
              subtitle: Column(
                children: safeUser!.quizIds.map(
                  (id) {
                    final quiz = quizzes.getById(id);
                    return ListTile(
                      title: Text(quiz?.title ?? 'INVALID'),
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
        spacing: 8,
        children: [
          TextFormField(
            controller: quizNameField.controller,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.state.length,
              itemBuilder: (context, index) {
                final question = questions.state.elementAt(index);
                return OnReactive(
                  () => CheckboxListTile(
                    title: questions.state[index].statement.text(),
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
        ElevatedButton(
          onPressed: (selectedQuestionsRM.state.isEmpty)
              ? null
              : () async {
                  final quizId = await quizzes.put(
                    Quiz()
                      ..questions = selectedQuestionsRM.state
                      ..title = quizNameField.text
                      ..userId = safeUser?.id,
                  );
                  users.put(safeUser!..quizIds.add(quizId));
                  router.back();
                },
          child: Text('Save'),
        ),
      ],
    );
  }
}
