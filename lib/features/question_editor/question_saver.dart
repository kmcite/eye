import 'package:eye/domain/api/questions.dart';
import 'package:eye/features/question_editor/question_editor.dart';
import 'package:eye/main.dart';

class QuestionSaver extends UI {
  const QuestionSaver({super.key});

  @override
  Widget build(BuildContext context) {
    void onChangesSaved() {
      questions.put(localQuestionRM.of(context));
    }

    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: onChangesSaved,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
