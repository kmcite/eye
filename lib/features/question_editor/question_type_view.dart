import 'package:eye/domain/models/question.dart';
import 'package:eye/features/question_editor/question_editor.dart';
import 'package:eye/main.dart';

class QuestionTypeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final question = localQuestionRM.of(context);
    void onQuestionTypeChanged(QuestionType type) {
      localQuestionRM(context)
        ..state = (question..type = type)
        ..notify();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: QuestionType.values.map(
                (type) {
                  final isSelected = question.type == type;
                  return FilterChip(
                    label: Text(
                      type.toString().split('.').last,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : null,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) onQuestionTypeChanged(type);
                    },
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    showCheckmark: true,
                    checkmarkColor: Theme.of(
                      context,
                    ).colorScheme.onPrimary,
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
