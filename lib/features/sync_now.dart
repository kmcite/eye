import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';
import 'package:manager/extensions.dart';

class SyncNowDialog extends UI {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: 'SyncNow'.text(),
      content: 'Your content is out of date. Would you like to update now?'
          .text(),
      actions: [
        ElevatedButton(
          onPressed: cancel,
          child: 'Cancel'.text(),
        ),
        ElevatedButton(
          onPressed: proceed,
          child: 'Proceed'.text(),
        ),
      ],
    );
  }
}

extension on SyncNowDialog {
  void cancel() {
    router.back();
  }

  void proceed() {
    router.back();
  }
}
