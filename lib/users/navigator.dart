// import 'package:flutter/material.dart';

// class NavigationBloc extends LabeledGlobalKey<NavigatorState> {
//   NavigationBloc([super._debugLabel]);

//   NavigatorState? navigatorState() => this.currentState;

//   Future<T?> navigateTo<T>(Widget page) async {
//     return navigatorState()?.push(
//       MaterialPageRoute<T>(builder: (context) => page),
//     );
//   }

//   Future<T?> navigateToReplacement<T>(Widget page) async {
//     return navigatorState()?.pushReplacement(
//       MaterialPageRoute<T>(builder: (context) => page),
//     );
//   }

//   Future<T?> navigateToDialog<T>(Widget page) async {
//     return showDialog<T>(
//       context: this.currentContext!,
//       builder: (context) => page,
//     );
//   }

//   void navigateBack<T>([T? result]) {
//     navigatorState()?.pop<T>(result);
//   }
// }
