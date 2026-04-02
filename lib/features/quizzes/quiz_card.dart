import 'package:eye/domain/models/quiz.dart';
import 'package:eye/main.dart';

/// Reusable Quiz Card Widget for consistent quiz display across the app
class QuizCard extends UI {
  final Quiz quiz;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool showDeleteButton;

  const QuizCard({
    required this.quiz,
    required this.onTap,
    this.onDelete,
    this.showDeleteButton = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.quiz,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          quiz.title.isEmpty ? 'Untitled Quiz' : quiz.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${quiz.questions.length} ${quiz.questions.length == 1 ? 'question' : 'questions'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: showDeleteButton && onDelete != null
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: onDelete,
                tooltip: 'Delete quiz',
              )
            : Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// Empty state widget for when no quizzes are available
class QuizEmptyState extends UI {
  const QuizEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No Quizzes Found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a new quiz or search for existing ones',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
