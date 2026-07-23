// // import 'package:eye/authentication/authentication.dart';
// // import 'package:eye/users/logger.dart';
// // import 'package:eye/users/splash.dart';
// // import 'package:eye/users/users.dart';
// import 'package:eye/domain/models/app_user.dart';
// import 'package:eye/main.dart';
// // import 'package:eye/users/objectbox.dart';

// final user = computed<AppUser?>(() {
//   return null;
// });

// final userProgress = computed(() => user()?.progress.target);

// extension UsersRepository on Signal<List<AppUser>> {
//   AppUser? getByEmail(String value) {
//     return this()
//         .where((e) => e.email.toLowerCase() == value.toLowerCase())
//         .firstOrNull;
//   }
// }

// // typedef Apply = FutureOr<void> Function(dynamic action);

// class AppState {
//   // // List<AppUser> users = [];

//   // int? authentication;
//   // bool get authenticated => authentication != null;

//   // String email = '';
//   // String password = '';
//   // int tabIndex = 0;

//   /// DERIVED STATE

//   // /// DERIVED STATE
//   // bool get isUserAvailableByEmail =>
//   //     users.any((e) => e.email.toLowerCase() == email.toLowerCase());

//   /// REDUCER
// }

// // AppState appReducer(AppState state, action) {
// //   return switch (action) {
// //     UsersAction() => state..users = usersReducer(state.users, action),
// //     LoginAction() =>
// //       state
// //         ..authentication = authenticationReducer(state.authentication, action),
// //     LogoutAction() =>
// //       state
// //         ..authentication = authenticationReducer(state.authentication, action),
// //     RegisterAction() =>
// //       state
// //         ..authentication = authenticationReducer(state.authentication, action),
// //     GoToUsersScreenSuper() =>
// //       state
// //         ..authentication = authenticationReducer(state.authentication, action),
// //     _ => state,
// //   };
// // }

// // Future<void> appMiddleware(AppState state, action, Apply apply) async {
// //   await logger(state, action, apply);
// //   // await authenticationMiddleware(state, action, apply);
// //   await objectbox(state, action, apply);
// //   await splash(state, action, apply);
// // }

// // extension ouch on BuildContext {
// //   AppState get state =>
// //       dependOnInheritedWidgetOfExactType<ScopeProvider>()!.state;
// //   FutureOr<void> apply(action) =>
// //       dependOnInheritedWidgetOfExactType<ScopeProvider>()!.apply(action);
// // }

// // class ScopeProvider extends InheritedWidget {
// //   final Apply apply;
// //   final AppState state;
// //   const ScopeProvider({
// //     super.key,
// //     required this.apply,
// //     required this.state,
// //     required super.child,
// //   });

// //   @override
// //   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
// //     return true;
// //   }
// // }

// // class Scope extends StatefulWidget {
// //   final Widget child;
// //   const Scope(
// //     this.child, {
// //     super.key,
// //   });
// //   @override
// //   State<Scope> createState() => _ScopeState();
// // }

// // class _ScopeState extends State<Scope> {
// //   AppState state = AppState();
// //   Future<void> apply(action) async {
// //     /// APPLY MIDDLEWARES
// //     await appMiddleware(state, action, apply);

// //     /// REDUCE STATES
// //     setState(() => state = appReducer(state, action));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return ScopeProvider(
// //       apply: apply,
// //       state: state,
// //       child: widget.child,
// //     );
// //   }
// // }
