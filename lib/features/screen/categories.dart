import 'package:eye/business/categories_notifier.dart';
import 'package:eye/business/questions_notifier.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/features/dialogs/new_category_dialog.dart';
import 'package:eye/features/screen/mcq_study.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/widgets.dart';

class CategoriesScreen extends SignalConsumer {
  const CategoriesScreen({super.key});

  void _openCategoryDialog() {
    router.presentDialog(const NewCategoryDialog());
  }

  @override
  Widget build(BuildContext context) {
    final rm = categoriesNotifierProvider();
    final questions = questionsNotifierProvider();
    rm.ensureLoaded();

    return EyeScaffold(
      title: 'Study topics',
      primaryAction: EyeFab(
        label: 'Topic',
        onPressed: () {
          rm.select(null);
          _openCategoryDialog();
        },
      ),
      body: switch (true) {
        _ when rm.loading() => const Center(child: EyeSpinner()),
        _ when rm.error() != null => _ErrorState(onRetry: rm.initialize),
        _ => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: EyeSearchField(
                placeholder: 'Search topics…',
                onChanged: rm.search.set,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Categories',
                subtitle: 'Each topic groups MCQs. Tap Study to practice.',
              ),
            ),
            Expanded(
              child: rm.filtered().isEmpty
                  ? _EmptyCategories(
                      onCreate: () {
                        rm.select(null);
                        _openCategoryDialog();
                      },
                    )
                  : EyeRefreshScrollView(
                      onRefresh: rm.initialize,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index == 0) {
                                    final total = questions.questions().length;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _AllTopicsCard(
                                        count: total,
                                        onStudy: total == 0
                                            ? null
                                            : () => router.push(
                                                const McqStudyScreen(
                                                  title: 'All topics',
                                                ),
                                              ),
                                      ),
                                    );
                                  }

                                  final category = rm.filtered()[index - 1];
                                  final count = questions.countInCategory(
                                    category.id,
                                  );

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _CategoryStudyCard(
                                      name: category.name,
                                      questionCount: count,
                                      onStudy: count == 0
                                          ? null
                                          : () => router.push(
                                              McqStudyScreen(
                                                categoryId: category.id,
                                                title: category.name,
                                              ),
                                            ),
                                      onEdit: () {
                                        rm.select(category);
                                        _openCategoryDialog();
                                      },
                                      onDelete: () =>
                                          _confirmDelete(context, rm, category),
                                    ),
                                  );
                                },
                                childCount: rm.filtered().length + 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      },
    );
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    CategoriesNotifier rm,
    Category category,
  ) async {
    final ok = await appRouter().confirm(
      title: 'Delete topic?',
      message: 'Remove "${category.name}" from your bank.',
      confirm: 'Delete',
      isDestructive: true,
    );
    if (ok == true) await rm.delete(category);
  }
}

class _CategoryStudyCard extends SignalConsumer {
  const _CategoryStudyCard({
    required this.name,
    required this.questionCount,
    required this.onStudy,
    required this.onEdit,
    required this.onDelete,
  });

  final String name;
  final int questionCount;
  final VoidCallback? onStudy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  void _menu() {
    router.presentSheet(
      EyeOptionsSheet(
        title: name,
        actions: [
          EyeSheetAction(
            label: 'Rename',
            icon: EyeIcons.pencil,
            onPressed: () {
              router.pop();
              onEdit();
            },
          ),
          EyeSheetAction(
            label: 'Delete',
            icon: EyeIcons.delete,
            destructive: true,
            onPressed: () {
              router.pop();
              onDelete();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
              EyeIconButton(
                icon: EyeIcons.ellipsis,
                size: 18,
                onPressed: _menu,
              ),
            ],
          ),
          Text(
            questionCount == 0
                ? 'No MCQs yet'
                : '$questionCount question${questionCount == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: 13,
              color: context.eyeTheme.secondaryLabel,
            ),
          ),
          const SizedBox(height: 12),
          EyePrimaryButton(
            label: questionCount == 0 ? 'Add questions first' : 'Study',
            icon: EyeIcons.book,
            onPressed: onStudy,
          ),
        ],
      ),
    );
  }
}

class _AllTopicsCard extends StatelessWidget {
  const _AllTopicsCard({required this.count, required this.onStudy});

  final int count;
  final VoidCallback? onStudy;

  @override
  Widget build(BuildContext context) {
    final primary = context.eyeTheme.primary;
    return GlassPanel(
      child: Row(
        children: [
          Icon(EyeIcons.layers, color: primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mixed review',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text('$count MCQs across all topics'),
              ],
            ),
          ),
          EyeTextButton(label: 'Study', onPressed: onStudy),
        ],
      ),
    );
  }
}

class _EmptyCategories extends SignalConsumer {
  const _EmptyCategories({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return EyeEmptyState(
      icon: EyeIcons.folder,
      title: 'Create your first topic',
      message: 'Topics help organize ophthalmology MCQs for focused study.',
      action: EyePrimaryButton(
        label: 'New topic',
        icon: EyeIcons.add,
        onPressed: onCreate,
      ),
    );
  }
}

class _ErrorState extends SignalConsumer {
  const _ErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return EyeEmptyState(
      icon: EyeIcons.cloudDownload,
      title: 'Could not load topics',
      action: EyePrimaryButton(
        label: 'Retry',
        icon: EyeIcons.refresh,
        onPressed: () => onRetry(),
      ),
    );
  }
}
