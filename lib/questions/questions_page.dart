import 'package:eye/categories/categories.dart';
import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:eye/questions/questions_repository.dart';
import 'package:eye/questions/question_page.dart';
import 'package:forui/forui.dart';

final _questions = QuestionsBloc();

class QuestionsBloc extends Bloc {
  Iterable<Question> get filteredQuestions {
    final cached = questionsRepository.getAll();
    if (selectedCategory != null) {
      return cached.where(
        (question) => question.categoryId == selectedCategory!.id,
      );
    }
    return questionsRepository.getAll();
  }

  Iterable<Category> get categories => categoriesRepository.getAll();

  void put(Question question) => questionsRepository.put(question);
  void toQuestion(Question question) {
    questionsRepository.question = question;
    to(QuestionPage());
  }

  final categoryRM = RM.inject<Category?>(() => null);
  Category? get selectedCategory => categoryRM.state;
  void selectCategory(Category? value) {
    selectedCategory == value
        ? categoryRM.state = null
        : categoryRM.state = value;
    categoryRM.notify();
  }

  Category? getCategory(Question question) =>
      categoriesRepository.get(question.categoryId ?? '');
}

class QuestionsPage extends UI {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [
          FHeaderAction.back(
            onPress: _questions.back,
          ),
        ],
        title: 'Questions'.text(),
      ),
      content: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _questions.categories
                  .map(
                    (category) => FTappable(
                      onPress: () => _questions.selectCategory(category),
                      child: FBadge(
                        label: category.name.text(),
                        style: _questions.selectedCategory == category
                            ? FBadgeStyle.primary
                            : FBadgeStyle.outline,
                      ),
                    ).pad(all: 4),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: FTileGroup.builder(
              divider: FTileDivider.full,
              count: _questions.filteredQuestions.length,
              tileBuilder: (context, index) {
                final question = _questions.filteredQuestions.elementAt(index);
                return FTile(
                  title: question.statement.text().pad(),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      FBadge(
                        label: question.id.text(),
                      ),
                      if (_questions.getCategory(question) != null)
                        FBadge(
                          label: _questions.getCategory(question)!.name.text(),
                        )
                    ],
                  ),
                  onPress: () => _questions.toQuestion(question),
                );
              },
            ),
          ),
        ],
      ),
      footer: FButton(
        onPress: () {
          _questions.put(Question());
        },
        label: Icon(Icons.add),
      ).pad(),
    );
  }
}
