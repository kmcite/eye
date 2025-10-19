import 'package:eye/domain/models/quiz.dart';
import 'package:eye/main.dart';

final quizRM = Quiz().inj();

_save() {}
_cancel() {}

class NewQuizDialog extends UI {
  @override
  Widget build(BuildContext context) {
    return FDialog(
      actions: [
        FButton(
          onPress: _save,
          child: 'Save'.text(),
        ),
        FButton(
          onPress: _cancel,
          child: 'Save'.text(),
        ),
      ],
    );
  }
}
