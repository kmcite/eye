import 'package:eye/business/categories_notifier.dart';
import 'package:eye/business/new_question_notifier.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';

class NewQuestionSheet extends SignalConsumer {
  const NewQuestionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final addQuestion = newQuestionNotifierProvider();
    final categories = categoriesNotifierProvider();
    categories.ensureLoaded();

    final valid = addQuestion.isValid();
    final submitting = addQuestion.isSubmitting();
    final selectedId = addQuestion.categoryId();
    final topicLabel = selectedId == 0
        ? 'No topic'
        : categories.getById(selectedId)?.name ?? 'Topic';

    void pickTopic() {
      router.presentSheet(
        EyeOptionsSheet(
          title: 'Topic',
          actions: [
            EyeSheetAction(
              label: 'No topic',
              icon: EyeIcons.folder,
              onPressed: () {
                addQuestion.categoryId.value = 0;
                router.pop();
              },
            ),
            ...categories.categories().map(
              (c) => EyeSheetAction(
                label: c.name,
                icon: EyeIcons.folder,
                onPressed: () {
                  addQuestion.categoryId.value = c.id;
                  router.pop();
                },
              ),
            ),
          ],
        ),
      );
    }

    Future<void> submit() async {
      final success = await addQuestion.submit();
      if (success) {
        addQuestion.clear();
        router.pop();
      }
    }

    return EyeSheetFrame(
      title: 'New MCQ',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (addQuestion.error() != null) ...[
              InlineMessage.error(addQuestion.error()!),
              const SizedBox(height: 12),
            ],
            EyeFieldGroup(
              label: 'Topic',
              child: EyeTap(
                onPressed: pickTopic,
                semanticButton: false,
                minSize: 0,
                glass: true,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(EyeIcons.folder, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(topicLabel)),
                      const Icon(EyeIcons.chevronDown, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            EyeTextField(
              placeholder: 'Question stem',
              maxLines: 4,
              onChanged: addQuestion.statement.set,
            ),
            const SizedBox(height: 12),
            Text(
              'Options (tap letter for correct key)',
              style: context.eyeTheme.sectionLabel,
            ),
            const SizedBox(height: 8),
            ..._optionFields(context, addQuestion),
            const SizedBox(height: 12),
            EyeTextField(
              placeholder: 'Explanation',
              maxLines: 3,
              onChanged: addQuestion.explanation.set,
            ),
          ],
        ),
      ),
      actions: Row(
        children: [
          Expanded(
            child: EyeTextButton(
              label: 'Cancel',
              onPressed: () {
                addQuestion.clear();
                router.pop();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: EyePrimaryButton(
              label: submitting ? 'Saving…' : 'Save',
              onPressed: valid && !submitting ? submit : null,
              expand: true,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _optionFields(BuildContext context, NewQuestionNotifier logic) {
    const fields = <(String, int)>[
      ('A', 0),
      ('B', 1),
      ('C', 2),
      ('D', 3),
    ];
    return [
      for (final (label, index) in fields) ...[
        _buildOptionField(context, label, index, logic),
        const SizedBox(height: 8),
      ],
    ];
  }

  Widget _buildOptionField(
    BuildContext context,
    String label,
    int index,
    NewQuestionNotifier logic,
  ) {
    final selected = logic.correctIndex() == index;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EyeChip(
          label: label,
          selected: selected,
          onTap: () => logic.setCorrectIndex(index),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: EyeTextField(
            placeholder: 'Answer $label',
            onChanged: switch (index) {
              0 => logic.optionA.set,
              1 => logic.optionB.set,
              2 => logic.optionC.set,
              3 => logic.optionD.set,
              _ => logic.optionA.set,
            },
          ),
        ),
      ],
    );
  }
}
