import 'package:eye/domain/api/categories.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/features/question_editor/question_editor.dart';
import 'package:eye/main.dart';
import 'package:eye/domain/api/questions.dart';
import 'package:eye/utils/router.dart';
import 'package:yaru/yaru.dart';

Category? getCategory(Question question) =>
    categories.getById(question.categoryId ?? -1);

Iterable<Question> get filteredQuestions {
  Iterable<Question> filtered = questions.state;

  // Filter by category if selected
  if (selectedCategory != null) {
    filtered = filtered.where(
      (question) => question.categoryId == selectedCategory?.id,
    );
  }

  // Filter by search query if not empty
  if (searchQuery.isNotEmpty) {
    filtered = filtered.where(
      (question) =>
          question.statement.toLowerCase().contains(searchQuery.toLowerCase()),
    );
  }

  return filtered.toList();
}

final categoryRM = RM.inject<Category?>(() => null);
Category? get selectedCategory => categoryRM.state;
void selectCategory(Category? value) {
  selectedCategory?.id == value?.id
      ? categoryRM.state = null
      : categoryRM.state = value;
  categoryRM.notify();
}

final searchQueryRM = RM.inject<String>(() => '');
String get searchQuery => searchQueryRM.state;
void setSearchQuery(String value) {
  searchQueryRM.state = value;
  searchQueryRM.notify();
}

class QuestionsPage extends UI {
  static const route = '/questions';
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add new question',
            onPressed: () => questions.put(Question()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search questions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) => setSearchQuery(value),
            ),
          ),

          // Categories Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // All Categories Chip
                      FilterChip(
                        label: const Text('All'),
                        selected: selectedCategory == null,
                        onSelected: (_) => selectCategory(null),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: selectedCategory == null
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Category Chips
                      ...categories.state.map((category) {
                        final isSelected = selectedCategory?.id == category.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category.name),
                            selected: isSelected,
                            onSelected: (_) => selectCategory(category),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            selectedColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Questions List
          Expanded(
            child: questions.loading
                ? const Center(child: YaruCircularProgressIndicator())
                : filteredQuestions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No questions found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedCategory != null
                              ? 'Try changing the category filter'
                              : 'Add a new question to get started',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredQuestions.length,
                    itemBuilder: (context, index) {
                      final question = filteredQuestions.elementAt(index);
                      final category = getCategory(question);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          title: Text(
                            question.statement,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (category != null) ...[
                                const SizedBox(height: 4),
                                Chip(
                                  label: Text(
                                    category.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                        ),
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                'ID: ${question.id}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            router.to(
                              QuestionPage.route,
                              arguments: question,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
