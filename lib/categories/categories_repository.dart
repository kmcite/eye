import 'package:eye/main.dart';

import 'categories.dart';

class CategoriesRepository extends Collection<Category> {
  CategoriesRepository() : super(fromJson: Category.fromJson);
}
