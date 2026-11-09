import 'dart:async';

import 'package:eye/domain/repositories/questions_repository.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/utils/infrastructure.dart';

final questionsNotifierProvider = provider(
  () => QuestionsNotifier(questionsRepositoryProvider()),
);

class QuestionsNotifier {
  QuestionsNotifier(this.questionsRepository) {
    _sub = questionsRepository.watch().listen((value) {
      questions.value = value;
    });
    refresh();
  }

  final QuestionsRepository questionsRepository;
  late final StreamSubscription<List<Question>> _sub;

  final questions = signal(<Question>[]);
  final search = signal('');
  final category = nullSignal<Category>();

  late final filteredQuestions = computed(() {
    var filtered = questions();

    final cat = category();
    if (cat != null) {
      filtered = filtered.where((q) => q.categoryId == cat.id).toList();
    }

    final query = search().trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where((q) => q.statement.toLowerCase().contains(query))
          .toList();
    }
    return filtered;
  });

  int countInCategory(int categoryId) =>
      questions().where((q) => q.categoryId == categoryId).length;

  List<Question> forCategory(int categoryId) =>
      questions().where((q) => q.categoryId == categoryId).toList();

  Future<void> create(Question question) =>
      questionsRepository.create(question);

  Future<void> update(Question question) =>
      questionsRepository.update(question);

  Future<void> delete(int id) => questionsRepository.delete(id);

  Future<void> refresh() async {
    questions.value = await questionsRepository.getAll();
  }

  void dispose() => _sub.cancel();
}
