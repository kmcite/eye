import 'package:eye/domain/api/categories_repository.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/api.dart';

mixin NewCategoryBloc {
  final categoryRM = RM.inject<Category?>(() => null);
  Category? get category => categoryRM.state;
  onNameChanged(String name) {
    categoryRM.state = (category?..name = name);
  }

  void okay() {
    if (category != null) categoriesRepository.put(category!);
    cancel();
  }

  void cancel() {
    navigator.back();
    categoryRM.state = null;
  }
}

class NewCategoryDialog extends UI with NewCategoryBloc {
  NewCategoryDialog() {
    categoryRM.state = Category();
  }

  @override
  Widget build(BuildContext context) {
    return FDialog(
      actions: [
        FButton(
          onPress: okay,
          child: 'Okay'.text(),
        ),
        FButton(
          onPress: cancel,
          child: 'Cancel'.text(),
        ),
      ],
    );
  }
}
