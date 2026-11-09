import 'package:eye/domain/repositories/questions_repository.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/utils/infrastructure.dart';

final newQuestionNotifierProvider = provider(
  () => NewQuestionNotifier(questionsRepositoryProvider()),
);

class NewQuestionNotifier {
  NewQuestionNotifier(this.questionsRepository);

  final QuestionsRepository questionsRepository;

  final statement = signal('');
  final optionA = signal('');
  final optionB = signal('');
  final optionC = signal('');
  final optionD = signal('');
  final explanation = signal('');
  final categoryId = signal(0);
  final correctIndex = nullSignal<int>();
  final isSubmitting = signal(false);
  final error = nullSignal<String>();

  late final currentOptions = computed(
    () => [
      optionA(),
      optionB(),
      optionC(),
      optionD(),
    ].where((opt) => opt.trim().isNotEmpty).toList(),
  );

  late final isValid = computed(() {
    final index = correctIndex();
    if (statement().trim().isEmpty) return false;
    if (currentOptions().length < 2) return false;
    if (index == null || index >= currentOptions().length) return false;
    return true;
  });

  void setCorrectIndex(int index) => correctIndex.value = index;

  Future<bool> submit() async {
    if (!isValid()) {
      error.value = 'Fill the stem, provide at least 2 options, and select 1 correct answer.';
      return false;
    }

    error.value = null;
    isSubmitting.value = true;
    try {
      final q = Question(
        statement: statement().trim(),
        options: currentOptions(),
        correctIndex: correctIndex()!,
        explanation: explanation().trim(),
        categoryId: categoryId(),
      );
      await questionsRepository.create(q);
      clear();
      return true;
    } catch (e) {
      error.value = 'Failed to save question: $e';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  void clear() {
    statement.value = '';
    optionA.value = '';
    optionB.value = '';
    optionC.value = '';
    optionD.value = '';
    explanation.value = '';
    categoryId.value = 0;
    correctIndex.value = null;
    error.value = null;
  }
}
