import 'package:eye/domain/models/question.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';
import 'package:eye/domain/api/questions.dart';
import 'package:eye/domain/api/quizzes.dart';
import 'package:eye/domain/models/quiz.dart';

final currentQuestionIndexRM = 0.inj();

// ignore: must_be_immutable
class QuizTakingPage extends UI {
  static const route = '/quiz-taking';

  late Quiz? _quiz;
  Quiz get quiz => _quiz!;
  QuizTakingPage({super.key});

  late QuizAttempt _attempt;
  int _currentQuestionIndex = 0;
  final Map<int, List<int>> _userAnswers = {};

  @override
  void didMountWidget(BuildContext context) {
    _quiz = context.routeData.arguments;
    _startNewAttempt();
  }

  @override
  void didUnmountWidget() {
    _quiz = null;
  }

  void _startNewAttempt() async {
    _attempt = QuizAttempt()
      ..quizId = quiz.id
      ..startedAt = DateTime.now();
    _attempt.id = await quizAttempts.put(_attempt);
  }

  void _submitAnswer(List<int> selectedIndices) {
    final questionId = quiz.questions[currentQuestionIndexRM.state];
    _userAnswers[questionId] = selectedIndices;

    // Move to next question or finish quiz
    if (currentQuestionIndexRM.state < quiz.questions.length - 1) {
      currentQuestionIndexRM.state++;
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    int correct = 0;
    int total = quiz.questions.length;

    // Calculate score
    for (var questionId in _userAnswers.keys) {
      final question = questions.getById(questionId);
      if (question != null) {
        final userAnswer = _userAnswers[questionId] ?? [];
        final correctAnswers = question.correctAnswers;

        // Check if answers match exactly
        if (userAnswer.length == correctAnswers.length &&
            userAnswer.every((ans) => correctAnswers.contains(ans))) {
          correct++;
        }
      }
    }

    // Update attempt
    _attempt.endedAt = DateTime.now();
    _attempt.total = total;
    _attempt.correct = correct;
    quizAttempts.put(_attempt);

    // Show results
    router
        .toDialog(
          AlertDialog(
            title: const Text('Quiz Completed!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Score: $correct out of $total'),
                Text(
                  'Accuracy: ${(correct / total * 100).toStringAsFixed(1)}%',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => router.back(),
                child: const Text('OK'),
              ),
            ],
          ),
        )
        .then((_) => router.back());
  }

  @override
  Widget build(BuildContext context) {
    final questionId = quiz.questions[_currentQuestionIndex];
    final question = questions.getById(questionId);

    if (question == null) {
      return const Scaffold(
        body: Center(child: Text('Question not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${_currentQuestionIndex + 1} of ${quiz.questions.length}',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.statement,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (question.imageUrl != null) Image.network(question.imageUrl!),
            const SizedBox(height: 20),
            _buildOptions(question),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(Question question) {
    switch (question.type) {
      case QuestionType.mcqMultiple:
        return _buildMultipleChoice(question);
      case QuestionType.trueFalse:
        return _buildTrueFalse(question);
      case QuestionType.fillBlank:
        return _buildFillBlank(question);
      case QuestionType.imageBased:
        return _buildImageBased(question);
      case QuestionType.descriptive:
        return _buildDescriptive(question);
    }
  }

  Widget _buildMultipleChoice(Question question) {
    final selectedIndices = _userAnswers[question.id] ?? [];

    return Column(
      children:
          question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedIndices.contains(index);

            return CheckboxListTile(
                  title: Text(option),
                  value: isSelected,
                  onChanged: (bool? value) {
                    if (value == true) {
                      _userAnswers[question.id] = [...selectedIndices, index];
                    } else {
                      _userAnswers[question.id] = selectedIndices
                          .where((i) => i != index)
                          .toList();
                    }
                    currentQuestionIndexRM.notify();
                  },
                )
                as Widget;
          }).toList()..add(
            ElevatedButton(
              onPressed: () => _submitAnswer(selectedIndices),
              child: const Text('Submit Answer'),
            ),
          ),
    );
  }

  Widget _buildTrueFalse(Question question) {
    final selectedIndex = _userAnswers[question.id]?.firstOrNull;

    return Column(
      children: [
        RadioListTile<int>(
          title: const Text('True'),
          value: 0,
          groupValue: selectedIndex,
          onChanged: (value) {
            _userAnswers[question.id] = [0];
            currentQuestionIndexRM.notify();
          },
        ),
        RadioListTile<int>(
          title: const Text('False'),
          value: 1,
          groupValue: selectedIndex,
          onChanged: (value) {
            _userAnswers[question.id] = [1];
            currentQuestionIndexRM.notify();
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedIndex != null
              ? () => _submitAnswer([selectedIndex])
              : null,
          child: const Text('Submit Answer'),
        ),
      ],
    );
  }

  Widget _buildFillBlank(Question question) {
    final answerController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: answerController,
          decoration: const InputDecoration(
            labelText: 'Your answer',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: answerController.text.trim().isNotEmpty
              ? () => _submitAnswer([answerController.text.hashCode])
              : null,
          child: const Text('Submit Answer'),
        ),
      ],
    );
  }

  Widget _buildImageBased(Question question) {
    // Similar to multiple choice but with image
    return _buildMultipleChoice(question);
  }

  Widget _buildDescriptive(Question question) {
    final answerController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: answerController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Type your answer here',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: answerController.text.trim().isNotEmpty
              ? () => _submitAnswer([answerController.text.hashCode])
              : null,
          child: const Text('Submit Answer'),
        ),
      ],
    );
  }
}
