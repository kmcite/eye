import 'package:eye/business/users.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';
import 'package:eye/utils/navigator.dart';
import 'package:eye/domain/models/quiz.dart';

final currentQuestionIndexRM = 0.inj();
final Map<int, List<int>> _userAnswers = {};
late Quiz? _quiz;
late QuizAttempt _attempt;

// ignore: must_be_immutable
class QuizTakingPage extends UI {
  static const route = '/quiz-taking';

  const QuizTakingPage({super.key});

  Quiz get quiz => _quiz!;
  int get currentQuestionIndex => currentQuestionIndexRM.state;

  void init(BuildContext context) {
    _quiz = context.routeData.arguments;
    _startNewAttempt();
  }

  void _startNewAttempt() async {
    _attempt = QuizAttempt()
      ..quizId = quiz.id
      ..startedAt = DateTime.now()
      ..userId = user()?.id;
    _attempt.id = put(_attempt);
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
      final question = getById<Question>(questionId);
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
    put(_attempt);

    // Show results
    router
        .toDialog(
          QuizCompletedDialog(correct: correct, total: total),
        )
        .then((_) {
          router.back();
        });
  }

  @override
  Widget build(BuildContext context) {
    final questionId = quiz.questions[currentQuestionIndex];
    final question = getById<Question>(questionId);
    final hasEndReached = currentQuestionIndex >= quiz.questions.length - 1;
    final hasStarted = currentQuestionIndex > 0;

    if (question == null) {
      return const Scaffold(
        body: Center(child: Text('Question not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${currentQuestionIndex + 1} of ${quiz.questions.length}',
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: hasStarted
                  ? () {
                      currentQuestionIndexRM.state--;
                    }
                  : null,
              child: Icon(Icons.turn_left),
            ),
            Text('${currentQuestionIndexRM.state + 1}'),
            ElevatedButton(
              onPressed: hasEndReached
                  ? () => currentQuestionIndexRM.state++
                  : null,
              child: Icon(Icons.turn_right),
            ),
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
      spacing: 12,
      children: [
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedIndices.contains(index);

          return Card(
            child: CheckboxListTile(
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
            ),
          );
        }).toList(),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _submitAnswer(selectedIndices),
            child: const Text('Submit Answer'),
          ),
        ),
      ],
    );
  }

  Widget _buildTrueFalse(Question question) {
    final selectedIndex = _userAnswers[question.id]?.firstOrNull;

    return RadioGroup<int>(
      groupValue: selectedIndex,
      onChanged: (value) {
        if (value != null) _userAnswers[question.id] = [value];
        currentQuestionIndexRM.notify();
      },
      child: Column(
        spacing: 12,
        children: [
          Card(
            child: RadioListTile<int>(
              title: const Text('True'),
              value: 0,
            ),
          ),
          Card(
            child: RadioListTile<int>(
              title: const Text('False'),
              value: 1,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedIndex != null
                  ? () => _submitAnswer([selectedIndex])
                  : null,
              child: const Text('Submit Answer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFillBlank(Question question) {
    final answerController = TextEditingController();

    return Column(
      spacing: 16,
      children: [
        TextFormField(
          controller: answerController,
          decoration: InputDecoration(
            labelText: 'Your answer',
            hintText: 'Type your answer',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.edit),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: answerController.text.trim().isNotEmpty
                ? () => _submitAnswer([answerController.text.hashCode])
                : null,
            child: const Text('Submit Answer'),
          ),
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
      spacing: 16,
      children: [
        TextFormField(
          controller: answerController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Type your answer here',
            hintText: 'Provide a detailed answer',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.description),
            alignLabelWithHint: true,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: answerController.text.trim().isNotEmpty
                ? () => _submitAnswer([answerController.text.hashCode])
                : null,
            child: const Text('Submit Answer'),
          ),
        ),
      ],
    );
  }

  void dispose() {
    _quiz = null;
  }
}

class QuizCompletedDialog extends StatelessWidget {
  const QuizCompletedDialog({
    super.key,
    required this.correct,
    required this.total,
  });

  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quiz Completed!'),
      icon: Icon(
        Icons.check_circle,
        color: Color(0xFF4CAF50),
        size: 48,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          // Score Display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Final Score',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$correct',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'out of $total',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Accuracy
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Accuracy',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(correct / total * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => router.back(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
