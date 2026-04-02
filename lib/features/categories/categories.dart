import 'package:eye/domain/api/categories.dart';
import 'package:eye/domain/models/category.dart';
import 'package:eye/features/categories/new_category_dialog.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';
import 'package:eye/utils/navigator.dart';

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
        title: Text('Categories'),
      ),
      body: categories().isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create a category to get started',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: categories().length,
              itemBuilder: (context, index) {
                final category = categories().elementAt(index);
                return localCategoryRM.inherited(
                  builder: (context) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: Icon(Icons.category),
                        title: Text(category.name),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => router.toDialog(
                          localCategoryRM.reInherited(
                            context: context,
                            builder: (context) => UpdateCategoryDialog(),
                          ),
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
    );
  }
}

class UpdateCategoryDialog extends UI {
  final loadingRM = RM.inject(() => false);
  @override
  Widget build(BuildContext context) {
    final categoryChanges = localCategoryRM.of(context);
    final category = categoryChanges.category;
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
        // enabled: !categories.loading,
        initialValue: category.name,
        onChanged: (value) {
          updateCategoryChanges(true, category..name = value);
        },
        decoration: InputDecoration(labelText: 'Category'),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => router.back(),
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            put(category);
            router.back();
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
