import 'package:eye/utils/api.dart';
import 'package:eye/main.dart';

class SyncNowDialog extends UI {
  @override
  Widget build(BuildContext context) {
    return FDialog(
      title: 'SyncNow'.text(),
      body: 'Your content is out of date. Would you like to update now?'.text(),
      actions: [
        FButton(onPress: cancel, child: 'Cancel'.text()),
        FButton(onPress: proceed, child: 'Proceed'.text()),
      ],
    );
  }
}

extension on SyncNowDialog {
  void cancel() {
    navigator.back();
  }

  void proceed() {
    navigator.back();
  }
}
