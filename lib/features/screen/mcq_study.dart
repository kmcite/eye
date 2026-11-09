import 'package:eye/business/categories_notifier.dart';
import 'package:eye/business/questions_notifier.dart';
import 'package:eye/business/study_session_notifier.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';

/// Interactive MCQ study for one category or the full bank.
class McqStudyScreen extends SignalConsumer {
  const McqStudyScreen({
    super.key,
    this.categoryId = 0,
    this.singleQuestionId = 0,
    this.title = 'Study',
    this.shuffle = true,
  });

  final int categoryId;
  final int singleQuestionId;
  final String title;
  final bool shuffle;

  @override
  Widget build(BuildContext context) {
    final questions = questionsNotifierProvider();
    final categories = categoriesNotifierProvider();
    categories.ensureLoaded();
    final session = studySessionNotifierProvider();

    final pool = singleQuestionId != 0
        ? questions.questions().where((q) => q.id == singleQuestionId).toList()
        : categoryId == 0
        ? questions.questions()
        : questions.forCategory(categoryId);

    final sessionKey = singleQuestionId != 0
        ? 'q:$singleQuestionId'
        : categoryId == 0
        ? '__all__'
        : 'c:$categoryId';

    if (pool.isNotEmpty) {
      session.loadFor(sessionKey, pool, shuffle: shuffle);
    }

    final q = session.current;
    final done = session.finished();

    return EyeScaffold(
      title: title,
      body: pool.isEmpty
          ? _EmptyStudy(onAdd: () => router.pop())
          : done
          ? _Summary(
              session: session,
              onDone: () {
                session.reset();
                router.pop();
              },
            )
          : q == null
          ? const Center(child: EyeSpinner())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: GlassPanel(
                    padding: const EdgeInsets.all(14),
                    radius: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Question ${session.index() + 1} of ${session.items.length}',
                              style: context.eyeTheme.sectionLabel,
                            ),
                            const Spacer(),
                            if (session.answeredCount() > 0)
                              Text(
                                '${session.correctCount()}/${session.answeredCount()} correct',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context.eyeTheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        EyeProgressBar(value: session.progress()),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    children: [
                      if (q.categoryId != 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: EyeChip(
                              label:
                                  categories.getById(q.categoryId)?.name ??
                                  'Category',
                            ),
                          ),
                        ),
                      GlassPanel(
                        child: Text(
                          q.statement,
                          style: context.eyeTheme.titleLarge.copyWith(
                            fontSize: 18,
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(q.options.length, (i) {
                        return _OptionTile(
                          question: q,
                          index: i,
                          label: _optionLabel(i),
                          session: session,
                        );
                      }),
                      if (session.revealed() &&
                          q.explanation.trim().isNotEmpty) ...[
                        const SizedBox(height: 16),
                        InlineMessage.info(q.explanation),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: EyePrimaryButton(
                    expand: true,
                    label: !session.revealed()
                        ? 'Check answer'
                        : session.index() >= session.items.length - 1
                        ? 'See results'
                        : 'Next question',
                    onPressed: session.chosen() == null
                        ? null
                        : () {
                            if (!session.revealed()) {
                              session.checkAnswer();
                            } else if (!session.next()) {
                              session.index.value = session.items.length;
                            }
                          },
                  ),
                ),
              ],
            ),
    );
  }

  static String _optionLabel(int index) {
    const labels = ['A', 'B', 'C', 'D', 'E', 'F'];
    return index < labels.length ? labels[index] : '${index + 1}';
  }
}

class _OptionTile extends SignalConsumer {
  const _OptionTile({
    required this.question,
    required this.index,
    required this.label,
    required this.session,
  });

  final Question question;
  final int index;
  final String label;
  final StudySessionNotifier session;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    final primary = theme.primary;
    final revealed = session.revealed();
    final chosen = session.chosen();
    final isCorrect = index == question.correctIndex;
    final isChosen = chosen == index;

    final highlighted = revealed || isChosen;
    final decoration = highlighted
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: switch (true) {
              _ when revealed && isCorrect => primary.withValues(alpha: 0.22),
              _ when revealed && isChosen => theme.error.withValues(alpha: 0.18),
              _ when isChosen => primary.withValues(alpha: 0.15),
              _ => theme.fill.withValues(alpha: 0.55),
            },
            border: Border.all(
              color: switch (true) {
                _ when revealed && isCorrect => primary,
                _ when revealed && isChosen => theme.error,
                _ when isChosen => primary,
                _ => theme.separator,
              },
              width: 1.5,
            ),
          )
        : Glass.panel(context, radius: 14);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: EyeTap(
        onPressed: revealed ? null : () => session.select(index),
        semanticButton: false,
        minSize: 0,
        borderRadius: BorderRadius.circular(14),
        child: DecoratedBox(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.fillSecondary.withValues(alpha: 0.85),
                    border: Border.all(color: theme.separator),
                  ),
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: Center(
                      child: Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.options[index],
                    style: theme.body.copyWith(fontSize: 16),
                  ),
                ),
                if (revealed && isCorrect)
                  Icon(EyeIcons.checkCircled, color: primary),
                if (revealed && isChosen && !isCorrect)
                  Icon(EyeIcons.xCircled, color: theme.error),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyStudy extends SignalConsumer {
  const _EmptyStudy({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return EyeEmptyState(
      icon: EyeIcons.questionDiamond,
      title: 'No questions yet',
      message: 'Add MCQs to this topic, then come back to practice.',
      action: EyeSecondaryButton(
        label: 'Go back',
        icon: EyeIcons.back,
        onPressed: onAdd,
      ),
    );
  }
}

class _Summary extends SignalConsumer {
  const _Summary({required this.session, required this.onDone});

  final StudySessionNotifier session;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    final total = session.answeredCount();
    final correct = session.correctCount();
    final pct = total == 0 ? 0 : ((correct / total) * 100).round();

    return EyeEmptyState(
      icon: EyeIcons.checkCircled,
      title: '$pct% correct',
      message: '$correct of $total answered correctly',
      action: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            pct >= 80 ? 'Great session!' : 'Keep practicing — spaced review helps retention.',
            textAlign: TextAlign.center,
            style: theme.caption,
          ),
          const SizedBox(height: 16),
          EyePrimaryButton(label: 'Done', expand: true, onPressed: onDone),
        ],
      ),
    );
  }
}
