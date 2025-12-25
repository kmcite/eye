import 'package:eye/domain/api/categories.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';
import 'package:manager/manager.dart';

mixin NewCategoryBloc {
  final categoryRM = RM.inject<Category?>(() => null);
  Category? get category => categoryRM.state;
  void onNameChanged(String name) {
    categoryRM.state = (category?..name = name);
  }

  void okay() {
    if (category != null) categories.put(category!);
    cancel();
  }

  void cancel() {
    router.back();
    categoryRM.state = null;
  }
}

class NewCategoryDialog extends UI with NewCategoryBloc {
  NewCategoryDialog() {
    categoryRM.state = Category();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Category'),
      content: TextFormField(
        decoration: InputDecoration(labelText: 'Category'),
        onChanged: onNameChanged,
        initialValue: category?.name,
      ),
      actions: [
        ElevatedButton(
          onPressed: okay,
          child: 'Okay'.text(),
        ),
        ElevatedButton(
          onPressed: cancel,
          child: 'Cancel'.text(),
        ),
      ],
    );
  }
}
