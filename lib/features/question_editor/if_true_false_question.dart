import 'package:eye/domain/models/question.dart';
import 'package:eye/features/question_editor/question_editor.dart';
import 'package:eye/main.dart';

class IfTrueFalseQuestion extends StatelessWidget {
  const IfTrueFalseQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    final question = localQuestionRM.of(context);
    if (question.type == QuestionType.trueFalse)
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Correct Answer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {
                        localQuestionRM(context)
                          ..state = (question..correctAnswers = [0])
                          ..notify();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: question.correctAnswers.contains(0)
                            ? Theme.of(
                                context,
                              ).colorScheme.primaryContainer
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        foregroundColor: question.correctAnswers.contains(0)
                            ? Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer
                            : null,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: question.correctAnswers.contains(0)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: const Text(
                        'True',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {
                        localQuestionRM(context)
                          ..state = (question..correctAnswers = [1])
                          ..notify();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: !question.correctAnswers.contains(0)
                            ? Theme.of(
                                context,
                              ).colorScheme.primaryContainer
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        foregroundColor: !question.correctAnswers.contains(0)
                            ? Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer
                            : null,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: !question.correctAnswers.contains(0)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: const Text(
                        'False',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    else {
      return const SizedBox.shrink();
    }
  }
}
