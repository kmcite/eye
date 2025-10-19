import 'dart:convert';
import 'package:eye/domain/models/category.dart';
import 'package:eye/main.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Question extends Model {
  @Id()
  int id = 0;

  // Core fields
  String statement = '';
  String explanation = '';
  String? imageUrl;

  // Enum index for QuestionType
  int typeIndex = 0;

  final category = ToOne<Category>();

  // Options and correct answers stored as JSON strings
  String optionsJson = '[]';
  String correctAnswersJson = '[]';

  // Getter and setter for options
  List<String> get options => List<String>.from(jsonDecode(optionsJson));
  set options(List<String> value) => optionsJson = jsonEncode(value);

  // Getter and setter for correct answers
  List<int> get correctAnswers =>
      List<int>.from(jsonDecode(correctAnswersJson));
  set correctAnswers(List<int> value) => correctAnswersJson = jsonEncode(value);

  // Getter and setter for QuestionType
  QuestionType get type => QuestionType.values[typeIndex];
  set type(QuestionType value) => typeIndex = value.index;

  // Utility methods
  bool isCorrectAnswer(int answerIndex) {
    return correctAnswers.contains(answerIndex);
  }

  bool isValid() {
    return statement.isNotEmpty &&
        options.isNotEmpty &&
        correctAnswers.isNotEmpty;
  }

  @override
  String toString() {
    return 'Question(id: $id, statement: "$statement", type: $type, options: $options, correctAnswers: $correctAnswers)';
  }
}

enum QuestionType {
  mcqMultiple, // Multiple-choice question with multiple answers
  trueFalse, // True/False question
  fillBlank, // Fill-in-the-blank question
  imageBased, // Image-based question
  descriptive // Descriptive question
}
