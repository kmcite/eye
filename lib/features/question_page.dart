// import 'package:collection/collection.dart';
// import 'package:eye/domain/api/categories_repository.dart';
// import 'package:eye/domain/api/navigation_repository.dart';
// import 'package:eye/domain/models/question.dart';
// import 'package:eye/domain/models/category.dart';
// import 'package:eye/main.dart';

// import '../../domain/api/questions_repository.dart';

// final _question = QuestionBloc();

// class QuestionBloc {
//   final hasChangesRM = RM.inject(() => false);

//   Modifier<Question> get question => questionsRepository.item;
//   void setQuestion(Question question) {
//     hasChangesRM.state = true;
//     questionsRepository.item(question);
//   }

//   String statement([String? value]) {
//     if (value != null) {
//       setQuestion(question()..statement = value);
//     }
//     return question().statement;
//   }

//   String explanation([String? value]) {
//     if (value != null) {
//       setQuestion(question()..explanation = value);
//     }
//     return question().explanation;
//   }

//   void addOption(String option) {
//     setQuestion(question()..options.add(option));
//   }

//   void removeOption(String option) {
//     setQuestion(question()..options.remove(option));
//   }

//   void addCorrectIndex(int index) {
//     setQuestion(question()..correctAnswers.add(index));
//   }

//   void removeCorrectIndex(int index) {
//     setQuestion(question()..correctAnswers.remove(index));
//   }

//   QuestionType type([QuestionType? value]) {
//     if (value != null) {
//       setQuestion(question()..type = value);
//     }
//     return question().type;
//   }

//   Category? get category =>
//       categoriesRepository.get(question().categoryId ?? 0);
//   void setCategory(Category value) {
//     setQuestion(question()..categoryId = value.id);
//   }

//   Iterable<Category> get categories => categoriesRepository.getAll();

//   bool get hasChanges {
//     return hasChangesRM.state;
//   }

//   void save() {
//     if (hasChanges) {
//       questionsRepository.put(question());
//       hasChangesRM.state = false;
//     } else {
//       navigator.back();
//     }
//   }
// }

// class QuestionPage extends UI {
//   const QuestionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final question = _question.question;
//     final isMcq =
//         question().type == QuestionType.mcqMultiple ||
//         question().type == QuestionType.bestChoice;
//     final isTrueFalse = question().type == QuestionType.trueFalse;
//     // final isDescriptive = question.type == QuestionType.descriptive;
//     return FScaffold(
//       header: FHeader.nested(
//         prefixActions: [FHeaderAction.back(onPress: navigator.back)],
//         suffixActions: [
//           if (_question.hasChanges)
//             FHeaderAction(
//               icon: FIcon(FAssets.icons.saveAll),
//               onPress: _question.save,
//             ),
//         ],
//         title: FBadge(
//           label:
//               _question.hasChanges
//                   ? 'has changes. save it.'.text()
//                   : 'saved. no pending changes.'.text(),
//         ),
//       ),
//       content: ListView(
//         children: [
//           // Statement
//           FTextField(
//             label: 'Statement'.text(),
//             initialValue: _question.statement(),
//             onChange: _question.statement,
//             minLines: 3,
//             maxLines: 5,
//           ),

//           // Explanation
//           FTextField(
//             label: 'Explanation'.text(),
//             initialValue: _question.explanation(),
//             onChange: _question.explanation,
//             minLines: 3,
//             maxLines: 5,
//           ),

//           // Category Type Selector
//           FTileGroup.builder(
//             label: 'Category'.text(),
//             description: _question.type().description.text(),
//             maxHeight: 200,
//             count: _question.categories.length,
//             tileBuilder: (context, index) {
//               final category = _question.categories.elementAt(index);
//               return FTile(
//                 enabled: category != _question.category,
//                 title: category.name.text(),
//                 onPress: () => _question.setCategory(category),
//               );
//             },
//           ),

//           /// Question Type Selector
//           FTileGroup.builder(
//             label: 'Type'.text(),
//             description: _question.type().description.text(),
//             maxHeight: 200,
//             count: QuestionType.values.length,
//             tileBuilder: (context, index) {
//               final type = QuestionType.values.elementAt(index);
//               return FTile(
//                 enabled: type != _question.type(),
//                 title: type.description.text(),
//                 onPress: () => _question.type(type),
//               );
//             },
//           ),

//           // Options List (only for MCQ and best choice)
//           if (isMcq)
//             Column(
//               children: [
//                 FHeader.nested(
//                   title: 'Options -> ${_question.type().name}'.text(),
//                   suffixActions: [
//                     FHeaderAction(
//                       icon: FIcon(FAssets.icons.plus),
//                       onPress: () => _question.addOption(''),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children:
//                       _question
//                           .question()
//                           .options
//                           .mapIndexed(
//                             (index, option) => Column(
//                               children: [
//                                 FTextField(
//                                   label: 'Option ${index + 1}'.text(),
//                                   initialValue: option,
//                                   onChange:
//                                       (value) =>
//                                           _question.question().options[index] =
//                                               value,
//                                 ),
//                                 FHeaderAction(
//                                   icon: FIcon(FAssets.icons.clapperboard),
//                                   onPress: () => _question.removeOption(option),
//                                 ),
//                               ],
//                             ),
//                           )
//                           .toList(),
//                 ),
//               ],
//             ),

//           // Correct Answer Selection
//           if (isMcq)
//             Column(
//               children: [
//                 FHeader.nested(title: 'Correct Answers'.text()),
//                 Column(
//                   children:
//                       _question
//                           .question()
//                           .options
//                           .mapIndexed(
//                             (index, option) => FTile(
//                               title: option.text(),
//                               enabled: _question
//                                   .question()
//                                   .correctAnswers
//                                   .contains(index),
//                               onPress: () {
//                                 if (question().type ==
//                                     QuestionType.bestChoice) {
//                                   _question.question().correctAnswers = [index];
//                                 } else {
//                                   if (_question
//                                       .question()
//                                       .correctAnswers
//                                       .contains(index)) {
//                                     _question.removeCorrectIndex(index);
//                                   } else {
//                                     _question.addCorrectIndex(index);
//                                   }
//                                 }
//                               },
//                             ),
//                           )
//                           .toList(),
//                 ),
//               ],
//             ),

//           // True/False Toggle
//           if (isTrueFalse)
//             FTile(
//               title:
//                   'Answer: '
//                           '${_question.question().correctAnswers.contains(0) ? 'True' : 'False'}'
//                       .text(),
//               subtitle: FSwitch(
//                 value: _question.question().correctAnswers.contains(0),
//                 onChange: (value) {
//                   _question.setQuestion(
//                     _question.question()..correctAnswers = value ? [0] : [1],
//                   );
//                 },
//               ),
//             ),

//           // Image Picker
//           FButton(
//             onPress: () {
//               // Image picker logic
//             },
//             label: "Any image for question?".text(),
//           ),
//         ],
//       ),
//     );
//   }
// }
