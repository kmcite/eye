import 'package:eye/authentication/authentication.dart';
import 'package:eye/business/authentication_state.dart';
import 'package:eye/features/home/home.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/ui.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spark/spark.dart';
import 'package:yaru/yaru.dart';

late final Injected<Box> boxRM;
void main() async {
  await Hive.initFlutter('eye');
  final box = await Hive.openBox('eye');
  boxRM = RM.inject(() => box);
  runApp(EyeApp());
}

class EyeApp extends UI {
  const EyeApp({super.key});
  void init() {}

  @override
  Widget build(BuildContext context) {
    final bool? dark = false;
    final authentication = authenticationSpark();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: dark.choose(.dark, .light, .system),
      theme: yaruLight,
      darkTheme: yaruDark,
      home: authentication.authenticated ? HomePage() : AutheticationPage(),
    );
  }
}

extension BoolNullableExtensions on bool? {
  T choose<T>(T whenTrue, T whenFalse, T whenNull) {
    if (this != null) {
      if (this!) {
        return whenTrue;
      } else {
        return whenFalse;
      }
    } else {
      return whenNull;
    }
  }
}

extension BoolExtensions on bool {
  T choose<T>(T whenTrue, T whenFalse) {
    if (this) {
      return whenTrue;
    } else {
      return whenFalse;
    }
  }
}

extension NavigationOn on Widget {
  void pop() {
    // final navigation = get<NavigationBloc>();
    // navigation.navigateBack();
  }

  void push(Widget widget) {
    // final navigation = get<NavigationBloc>();
    // navigation.navigateTo(widget);
  }

  void pushDialog(Widget widget) {
    // final navigation = get<NavigationBloc>();
    // navigation.navigateToDialog(widget);
  }

  void pushReplacement(Widget widget) {
    // final navigation = get<NavigationBloc>();
    // navigation.navigateToReplacement(widget);
  }
}
