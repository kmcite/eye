import 'package:eye/utils/infrastructure.dart';

final darkNotifierProvider = provider(() => DarkNotifier());

class DarkNotifier {
  final dark = signal<bool?>(false);

  void toggle() {
    dark.value = switch (dark()) {
      true => false,
      false => null,
      null => true,
    };
  }
}
