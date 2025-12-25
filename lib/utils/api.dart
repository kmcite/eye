import 'package:states_rebuilder/states_rebuilder.dart';

// final navigator = RM.navigate;
// final scaffold = RM.scaffold;

extension OnChanged<T> on Injected<T> {
  void onChanged(T value) {
    state = value;
  }
}
