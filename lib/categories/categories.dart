import 'package:eye/dependency_injection.dart';
import 'package:eye/main.dart';
import 'package:forui/forui.dart';

final _categories = CategoriesBloc();

class CategoriesBloc extends Bloc {
  Iterable<Category> get categories {
    return categoriesRepository.getAll();
  }

  void put(Category category) {
    categoriesRepository.put(category);
  }
}

class Category extends Model {
  String name = '';
  Category();
  Category.fromJson(json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class CategoriesPage extends UI {
  const CategoriesPage({super.key});

  @override
  Widget build(context) {
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [
          FHeaderAction.back(onPress: _categories.back),
        ],
        title: 'Categories'.text(),
      ),
      content: ListView(
        children: List.generate(
          _categories.categories.length,
          (index) {
            final category = _categories.categories.elementAt(index);
            return FTextField(
              initialValue: category.name,
              onChange: (value) {
                _categories.put(category..name = value);
              },
            ).pad();
          },
        ),
      ),
      footer: FButton(
        onPress: () {
          _categories.put(Category()..name = '____');
        },
        label: 'CREATE'.text(),
      ).pad(),
    );
  }
}
