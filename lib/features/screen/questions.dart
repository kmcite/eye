import 'package:eye/business/categories_notifier.dart';
import 'package:eye/business/questions_notifier.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/features/dialogs/new_question_dialog.dart' show NewQuestionSheet;
import 'package:eye/features/screen/mcq_study.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/widgets.dart';

class QuestionsScreen extends SignalConsumer {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final qm = questionsNotifierProvider();
    final filtered = qm.filteredQuestions();
    final categories = categoriesNotifierProvider();
    categories.ensureLoaded();

    return EyeScaffold(
      title: 'Question bank',
      primaryAction: EyeFab(
        label: 'MCQ',
        onPressed: () => router.presentSheet(const NewQuestionSheet()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: EyeSearchField(
              placeholder: 'Search stem or keywords…',
              onChanged: qm.search.set,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: EyeChip(
                    label: 'All topics',
                    selected: qm.category() == null,
                    onTap: () => qm.category.value = null,
                  ),
                ),
                ...categories.categories().map((cat) {
                  final selected = qm.category()?.id == cat.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: EyeChip(
                      label: cat.name,
                      selected: selected,
                      onTap: () => qm.category.value = cat,
                    ),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Expanded(
                  child: SectionHeader(
                    title: '${filtered.length} MCQs',
                    subtitle: qm.category()?.name ?? 'All topics',
                  ),
                ),
                if (filtered.isNotEmpty)
                  EyeTextButton(
                    label: 'Practice',
                    onPressed: () {
                      final cat = qm.category();
                      router.push(
                        McqStudyScreen(
                          categoryId: cat?.id ?? 0,
                          title: cat?.name ?? 'Practice',
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyQuestions(
                    onAdd: () => router.presentSheet(const NewQuestionSheet()),
                  )
                : EyeRefreshScrollView(
                    onRefresh: qm.refresh,
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                          sliver: SliverList.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final question = filtered[index];
                              final topic = question.categoryId == 0
                                  ? null
                                  : categories.getById(question.categoryId);

                              return _McqListCard(
                                question: question,
                                topicName: topic?.name,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _McqListCard extends SignalConsumer {
  const _McqListCard({
    required this.question,
    required this.topicName,
  });

  final Question question;
  final String? topicName;

  Future<void> _delete() async {
    final qm = questionsNotifierProvider();
    final ok = await router.confirm(
      title: 'Delete MCQ?',
      message: 'Remove this question from your bank.',
      confirm: 'Delete',
      isDestructive: true,
    );
    if (ok == true) await qm.delete(question.id);
  }

  @override
  Widget build(BuildContext context) {
    void onPractice() => router.push(
          McqStudyScreen(
            singleQuestionId: question.id,
            title: 'Review',
            shuffle: false,
          ),
        );
    final labels = ['A', 'B', 'C', 'D'];
    final correct = question.correctIndex < labels.length
        ? labels[question.correctIndex]
        : '${question.correctIndex + 1}';

    return EyeTap(
      onPressed: onPractice,
      semanticButton: false,
      minSize: 0,
      child: GlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.statement,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (topicName != null) EyeChip(label: topicName!),
                EyeChip(label: 'Key $correct'),
                EyeChip(label: '${question.options.length} options'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                EyeTextButton(
                  label: 'Try this question',
                  onPressed: onPractice,
                ),
                const Spacer(),
                EyeIconButton(
                  icon: EyeIcons.delete,
                  color: context.eyeTheme.error,
                  glass: true,
                  onPressed: _delete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyQuestions extends SignalConsumer {
  const _EmptyQuestions({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return EyeEmptyState(
      icon: EyeIcons.questionDiamond,
      title: 'Build your MCQ bank',
      message: 'Add multiple-choice items with explanations for spaced review.',
      action: EyePrimaryButton(
        label: 'Add MCQ',
        icon: EyeIcons.add,
        onPressed: onAdd,
      ),
    );
  }
}
