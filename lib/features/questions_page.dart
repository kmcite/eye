import 'package:eye/domain/api/categories_repository.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/main.dart';
import 'package:eye/domain/api/questions_repository.dart';
import 'package:eye/utils/api.dart';

Category? getCategory(Question question) =>
    categoriesRepository.get(question.category.targetId);
void put(Question question) => questionsRepository.put(question);
void questionDetails(Question question) {
  // questionsRepository.item(question);
  // navigator.to(QuestionPage());
}

Iterable<Question> get filteredQuestions {
  if (selectedCategory != null) {
    return questionsRM.state.where(
      (question) => question.category.targetId == selectedCategory?.id,
    );
  }
  return questionsRepository.getAll();
}

final categoryRM = RM.inject<Category?>(() => null);
Category? get selectedCategory => categoryRM.state;
void selectCategory(Category? value) {
  selectedCategory == value
      ? categoryRM.state = null
      : categoryRM.state = value;
  categoryRM.notify();
}

final categoriesRM = RM.injectStream(
  categoriesRepository.watch,
  initialState: categoriesRepository(),
);

final questionsRM = RM.injectStream(
  () => questionsRepository.watch(),
  initialState: questionsRepository(),
);

class QuestionsPage extends UI {
  QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton.icon(
            child: Icon(FIcons.arrowLeft),
            onPress: navigator.back,
          ),
        ],
        suffixes: [
          FButton.icon(
            child: Icon(FIcons.plus),
            onPress: () => put(Question()),
          ),
        ],
        title: 'Questions'.text(),
      ),
      child: Column(
        children: [
          FTextField(
            label: 'search'.text(),
            onChange: (value) {},
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                categoriesRM.state.length,
                (index) {
                  final category = categoriesRM.state[index];
                  return FTappable(
                    onPress: () => selectCategory(category),
                    child: FBadge(
                      child: category.name.text(),
                      style: selectedCategory == category
                          ? FBadgeStyle.primary
                          : FBadgeStyle.outline,
                    ),
                  ).pad(all: 4);
                },
              ),
            ),
          ),
          Expanded(
            child: FTileGroup.builder(
              label: 'filtered_questions'.text(),
              divider: FTileDivider.full,
              count: filteredQuestions.length,
              tileBuilder: (context, index) {
                final question = filteredQuestions.elementAt(index);
                return FTile(
                  title: question.statement.text().pad(),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      FBadge(child: question.id.text()),
                      // if (getCategory(question) != null)
                      //   FBadge(label: getCategory(question)!.name.text()),
                    ],
                  ),
                  onPress: () => questionDetails(question),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
