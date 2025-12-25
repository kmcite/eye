import 'package:eye/utils/object_box.dart';
import 'package:eye/domain/models/category.dart';

final categories = CategoriesRepository();

class CategoriesRepository with ObjectBox<Category> {}
