import 'package:eye/domain/api/categories.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/features/question_editor/if_true_false_question.dart';
import 'package:eye/features/question_editor/image_picker_view.dart';
import 'package:eye/features/question_editor/options.dart';
import 'package:eye/features/question_editor/question_saver.dart';
import 'package:eye/features/question_editor/question_type_view.dart';
import 'package:eye/main.dart';

/// INHERITED API
final localQuestionRM = RM.inject<Question>(() => throw UnimplementedError());

class QuestionPage extends UI {
  QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final question = localQuestionRM.of(context);
    final isMcq =
        question.type == QuestionType.mcqMultiple ||
        question.type == QuestionType.descriptive;

    /// MUTATIONS
    void onExplanationChanged(String explanation) {
      localQuestionRM(context)
        ..state = (question..explanation = explanation)
        ..notify();
    }

    void onStatementChanged(String statement) {
      localQuestionRM(context)
        ..state = (question..statement = statement)
        ..notify();
    }

    void onCategoryChanged(int? categoryId) {
      localQuestionRM(context)
        ..state = (question..categoryId = categoryId)
        ..notify();
    }

    /// BUILD
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question Editor',
          style: Theme.of(context).textTheme.headlineSmall,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            QuestionTypeView(),

            // Statement
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question Statement',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter your question here',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      initialValue: question.statement,
                      onChanged: onStatementChanged,
                      minLines: 3,
                      maxLines: 5,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Explanation
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explanation',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Add explanation (optional)',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      initialValue: question.explanation,
                      onChanged: onExplanationChanged,
                      minLines: 2,
                      maxLines: 4,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category Selector
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      initialValue: question.categoryId,
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('Select a category'),
                        ),
                        ...categories.state.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        onCategoryChanged(value);
                      },
                      isExpanded: true,
                    ),
                  ],
                ),
              ),
            ),

            if (isMcq) ...[
              const SizedBox(height: 16),

              // Options Section
              OptionsManager(),
            ],

            IfTrueFalseQuestion(),

            const SizedBox(height: 16),
            // Image Picker
            ImagePickerView(),
            const SizedBox(height: 24),
            // Save Button (sticky at bottom)
            // if (hasChanges)
            QuestionSaver(),
          ],
        ),
      ),
    );
  }

  static const route = '/question_editor';
}
