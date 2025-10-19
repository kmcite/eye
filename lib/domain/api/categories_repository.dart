import 'package:eye/domain/models/category.dart';
import 'package:eye/main.dart';

final categoriesRepository = CategoriesRepository();

class CategoriesRepository extends CRUD<Category> {}
