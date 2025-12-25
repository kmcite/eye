import 'package:collection/collection.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/features/question_editor/question_editor.dart';
import 'package:eye/main.dart';

class OptionsManager extends UI {
  const OptionsManager({super.key});
  @override
  Widget build(BuildContext context) {
    final question = localQuestionRM.of(context);

    /// MUTATIONS
    void onOptionAdded(String option) {
      localQuestionRM(context)
        ..state = (question..options.add(option))
        ..notify();
    }

    void onOptionRemoved(int index) {
      localQuestionRM(context)
        ..state = (question..options.removeAt(index))
        ..notify();
    }

    void onCorrectIndexAdded(int index) {
      localQuestionRM(context)
        ..state = (question..correctAnswers.add(index))
        ..notify();
    }

    void onCorrectIndexRemoved(int index) {
      localQuestionRM(context)
        ..state = (question..correctAnswers.remove(index))
        ..notify();
    }

    /// BUILD
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Options',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => onOptionAdded(''),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Option'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (question.options.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.outline,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No options added yet. Click "Add Option" to get started.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...question.options.mapIndexed((index, option) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: question.correctAnswers.contains(index)
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                              border: Border.all(
                                color: question.correctAnswers.contains(index)
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: question.correctAnswers.contains(index)
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: option,
                              decoration: InputDecoration(
                                labelText: 'Option ${index + 1}',
                                hintText: 'Enter option text',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 4,
                                ),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                              onChanged: (value) {
                                localQuestionRM(context)
                                  ..state = (question..options[index] = value)
                                  ..notify();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  question.correctAnswers.contains(index)
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: question.correctAnswers.contains(index)
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.outline,
                                ),
                                onPressed: () {
                                  if (question.type ==
                                      QuestionType.descriptive) {
                                    localQuestionRM(context)
                                      ..state = (question
                                        ..correctAnswers = [index])
                                      ..notify();
                                  } else if (question.correctAnswers.contains(
                                    index,
                                  )) {
                                    onCorrectIndexRemoved(index);
                                  } else {
                                    onCorrectIndexAdded(index);
                                  }
                                },
                                tooltip: question.correctAnswers.contains(index)
                                    ? 'Mark as incorrect'
                                    : 'Mark as correct',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                ),
                                onPressed: () => onOptionRemoved(index),
                                tooltip: 'Remove option',
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
