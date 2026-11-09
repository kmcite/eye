import 'dart:math';

import 'package:eye/domain/models/question.dart';
import 'package:eye/utils/infrastructure.dart';

final studySessionNotifierProvider = provider(() => StudySessionNotifier());

class StudySessionNotifier {
  String? _sourceKey;
  final _items = signal(<Question>[]);
  final index = signal(0);
  final chosen = nullSignal<int>();
  final revealed = signal(false);
  final correctCount = signal(0);
  final answeredCount = signal(0);

  List<Question> get items => _items();

  Question? get current {
    final list = _items();
    final i = index();
    if (i < 0 || i >= list.length) return null;
    return list[i];
  }

  late final progress = computed(() {
    final total = _items().length;
    if (total == 0) return 0.0;
    return (index() + 1) / total;
  });

  late final finished = computed(
    () => _items().isNotEmpty && index() >= _items().length,
  );

  void loadFor(
    String sessionKey,
    List<Question> questions, {
    bool shuffle = true,
  }) {
    final key = sessionKey;
    if (_sourceKey == key && _items().isNotEmpty && !finished()) return;
    _sourceKey = key;
    load(questions, shuffle: shuffle);
  }

  void load(
    List<Question> questions, {
    bool shuffle = true,
    int startAt = 0,
  }) {
    final list = List<Question>.of(questions);
    if (shuffle) list.shuffle(Random());
    _items.value = list;
    index.value = startAt.clamp(0, list.isEmpty ? 0 : list.length - 1);
    chosen.value = null;
    revealed.value = false;
    correctCount.value = 0;
    answeredCount.value = 0;
  }

  void select(int optionIndex) {
    if (revealed() || current == null) return;
    chosen.value = optionIndex;
  }

  void checkAnswer() {
    final q = current;
    final pick = chosen();
    if (q == null || pick == null || revealed()) return;

    revealed.value = true;
    answeredCount.value = answeredCount() + 1;
    if (pick == q.correctIndex) {
      correctCount.value = correctCount() + 1;
    }
  }

  bool next() {
    if (!revealed()) return false;
    final last = _items().length - 1;
    if (index() >= last) return false;
    index.value = index() + 1;
    chosen.value = null;
    revealed.value = false;
    return true;
  }

  void reset() {
    _sourceKey = null;
    _items.value = [];
    index.value = 0;
    chosen.value = null;
    revealed.value = false;
    correctCount.value = 0;
    answeredCount.value = 0;
  }
}
