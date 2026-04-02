import 'package:eye/domain/models/question.dart';
import 'package:eye/domain/models/quiz.dart';
import 'package:eye/features/quizzes/quiz/question_selector_dialog.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';
import 'package:eye/utils/navigator.dart';

class QuizPage extends UI {
  static const route = '/quiz';
  final quiz = signal<Quiz?>(null);

  QuizPage({super.key});
  void init(BuildContext context) {
    quiz(context.routeData.arguments as Quiz);
  }

  void dispose() {
    quiz(null);
  }

  @override
  Widget build(BuildContext context) {
    final quizDetails = this.quiz();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quizDetails!.title.isEmpty ? 'Untitled Quiz' : quizDetails.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add questions',
            onPressed: () => router.toDialog(
              QuestionSelectorDialog(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Delete quiz',
            onPressed: () {
              remove<Quiz>(quizDetails.id);
              router.back();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quiz Info Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Questions',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${quizDetails.questions.length}',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Icon(
                        Icons.quiz,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Quiz Title Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              initialValue: quizDetails.title,
              decoration: InputDecoration(
                labelText: 'Quiz Title',
                hintText: 'Enter quiz name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.edit),
              ),
              onChanged: (value) {
                quiz(quizDetails..title = value);
              },
            ),
          ),
          const SizedBox(height: 16),
          // Questions List
          Expanded(
            child: quizDetails.questions.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.help_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Questions Added',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the add button to start adding questions to this quiz',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: quizDetails.questions.length,
                    itemBuilder: (context, index) {
                      final questionId = quizDetails.questions.elementAt(index);
                      final question = getById<Question>(questionId);
                      if (question == null) {
                        return SizedBox.shrink();
                      }
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            question.statement,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          subtitle: Text(
                            'ID: ${question.id}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () {
                              quiz(quizDetails..questions.removeAt(index));
                            },
                            tooltip: 'Remove question',
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Add Questions Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => router.toDialog(QuestionSelectorDialog()),
                icon: Icon(Icons.add),
                label: Text('Add Questions'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
