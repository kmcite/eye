import 'package:eye/domain/api/categories.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/features/categories/new_category_dialog.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';
import 'package:manager/extensions.dart';
import 'package:yaru/yaru.dart';

final localCategoryRM = RM.inject<({Category category, bool hasChanges})>(
  () => throw UnimplementedError(),
);

class CategoriesPage extends UI {
  static const route = '/categories';

  const CategoriesPage({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              router.toDialog(NewCategoryDialog());
            },
          ),
          SizedBox(width: 8),
        ],
        title: 'Categories'.text(),
      ),
      body: Center(
        child: categories.loading
            ? YaruCircularProgressIndicator()
            : ListView.builder(
                itemCount: categories.state.length,
                itemBuilder: (context, index) {
                  final category = categories.state.elementAt(index);
                  return localCategoryRM.inherited(
                    builder: (context) {
                      return ListTile(
                        title: category.name.text(),
                        onTap: () => router.toDialog(
                          localCategoryRM.reInherited(
                            context: context,
                            builder: (context) => UpdateCategoryDialog(),
                          ),
                        ),
                      );
                    },
                    stateOverride: () => (
                      category: category,
                      hasChanges: false,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class UpdateCategoryDialog extends UI {
  final loadingRM = RM.inject(() => false);
  @override
  Widget build(BuildContext context) {
    final categoryChanges = localCategoryRM.of(context);
    final category = categoryChanges.category;
    final hasChanges = categoryChanges.hasChanges;
    void updateCategoryChanges(
      bool changes,
      Category category,
    ) {
      localCategoryRM(context).state = (
        category: category,
        hasChanges: changes,
      );
      localCategoryRM(context).notify();
    }

    return AlertDialog(
      title: Text('Change Category'),
      content: TextFormField(
        enabled: !categories.loading,
        initialValue: category.name,
        onChanged: (value) {
          updateCategoryChanges(true, category..name = value);
        },
        decoration: InputDecoration(labelText: 'Category'),
      ),
      actions: [
        if (categories.loading)
          YaruCircularProgressIndicator()
        else ...[
          if (hasChanges) Icon(Icons.info),
          FilledButton(
            onPressed: () => router.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await categories.put(category);
              router.back();
            },
            child: Text('Update'),
          ),
        ],
      ],
    );
  }
}
