import 'package:eye/domain/models/quiz.dart';
import 'package:eye/main.dart';

final quizRM = Quiz().inj();

_save() {}
_cancel() {}

class NewQuizDialog extends UI {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: _save,
          child: Text('Save'),
        ),
        ElevatedButton(
          onPressed: _cancel,
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
