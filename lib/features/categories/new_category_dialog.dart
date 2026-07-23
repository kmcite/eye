// import 'package:eye/domain/models/category.dart';
// import 'package:eye/main.dart'
//     show
//         signal,
//         UI,
//         BuildContext,
//         Widget,
//         Text,
//         InputDecoration,
//         TextFormField,
//         ElevatedButton,
//         FilledButton,
//         AlertDialog;
// import 'package:eye/users/objectbox.dart';
// import 'package:flutter/material.dart';

// final category = signal<Category?>(null);
// void onNameChanged(String name) {
//   category(category()?..name = name);
// }

// void okay() {
//   if (category() != null) put(category()!);
//   cancel();
// }

// void cancel() {
//   // router.back();
//   category(null);
// }

// class NewCategoryDialog extends SignalWidget {
//   init(BuildContext context) {
//     category(Category());
//   }

//   dispose() {
//     category(null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('New Category'),
//       content: TextFormField(
//         decoration: InputDecoration(labelText: 'Category'),
//         onChanged: onNameChanged,
//         initialValue: category()?.name,
//       ),
//       actions: [
//         ElevatedButton(
//           onPressed: cancel,
//           child: Text('Cancel'),
//         ),
//         FilledButton(
//           onPressed: okay,
//           child: Text('Create'),
//         ),
//       ],
//     );
//   }
// }
