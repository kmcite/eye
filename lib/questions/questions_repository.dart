import 'package:eye/main.dart';

final questionsRepository = QuestionsRepository(
  fromJson: Question.fromJson,
);

class QuestionsRepository extends Collection<Question> {
  QuestionsRepository({required super.fromJson});
  final questionRM = RM.inject<Question>(() => Question.none());

  Question get question => questionRM.state;
  set question(Question value) {
    questionRM
      ..state = value
      ..notify();
  }
}

class Question extends Model {
  String statement = '';
  String explanation = '';
  String _options = ''; // Backing field for storing options as JSON
  String _correctAnswers =
      ''; // Backing field for storing correct answers as JSON
  String? imageUrl;
  int typeIndex = 0;

  QuestionType get type => QuestionType.values[typeIndex];
  set type(QuestionType value) => typeIndex = value.index;

  List<String> get options {
    try {
      return List<String>.from(jsonDecode(_options));
    } catch (e) {
      return [];
    }
  }

  set options(List<String> value) {
    _options = jsonEncode(value);
  }

  List<int> get correctAnswers {
    try {
      return List<int>.from(jsonDecode(_correctAnswers));
    } catch (e) {
      return [];
    }
  }

  set correctAnswers(List<int> value) {
    _correctAnswers = jsonEncode(value);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'statement': statement,
      'explanation': explanation,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'typeIndex': typeIndex,
      '_options': _options,
      '_correctAnswers': _correctAnswers,
    };
  }

  Question();
  Question.none() {
    id = '';
  }

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    statement = json['statement'] ?? '';
    explanation = json['explanation'] ?? '';
    categoryId = json['categoryId'] ?? '';
    imageUrl = json['imageUrl'];
    typeIndex = json['typeIndex'] ?? 0;
    _options = json['_options'] ?? '[]';
    _correctAnswers = json['_correctAnswers'] ?? '[]';
  }
  String? categoryId;
}

enum QuestionType {
  mcqMultiple,
  trueFalse,
  fillBlank,
  imageBased,
  descriptive,
  bestChoice
}

extension QTX on QuestionType {
  String get description {
    return switch (this) {
      QuestionType.bestChoice => "Best Choice Question",
      QuestionType.mcqMultiple => "MCQ - multi-answers",
      QuestionType.trueFalse => "True/False",
      QuestionType.fillBlank => "Fill in the Blanks",
      QuestionType.imageBased => "Image Based Question",
      QuestionType.descriptive => "Descriptive Question",
    };
  }
}
