import 'package:eye/domain/api/categories_repository.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/features/categories/new_category_dialog.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/api.dart';

mixin class CategoriesBloc {
  Iterable<Category> get categories {
    return categoriesRepository.getAll();
  }

  void put(Category category) {
    categoriesRepository.put(category);
  }
}

class CategoriesPage extends UI with CategoriesBloc {
  const CategoriesPage({super.key});

  @override
  Widget build(context) {
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
            onPress: () {
              navigator.toDialog(NewCategoryDialog());
            },
          ),
        ],
        title: 'Categories'.text(),
      ),
      child: ListView(
        children: List.generate(categories.length, (index) {
          final category = categories.elementAt(index);
          return FTextField(
            initialText: category.name,
            onChange: (value) {
              put(category..name = value);
            },
          ).pad();
        }),
      ),
    );
  }
}
