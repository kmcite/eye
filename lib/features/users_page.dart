// import 'package:eye/domain/models/app_user.dart';
// import 'package:eye/domain/api/navigation_repository.dart';
// import 'package:eye/features/authentication/new_user_dialog.dart';
// import 'package:eye/domain/api/users_repository.dart';
// import 'package:eye/main.dart';

// import '../dashboard/dashboard_page.dart';

// final _users = UsersBloc();

// class UsersBloc {
//   Iterable<AppUser> get users => usersRepository.getAll();

//   void login(AppUser user) {
//     usersRepository.item(user);
//     navigator.toAndRemoveUntil(DashboardPage());
//   }

//   void remove(AppUser user) {
//     usersRepository.remove(user.id);
//   }

//   late var back = navigator.back;

//   void createNewUser() async {
//     final result = await navigator.toDialog<AppUser>(NewUserDialog());
//     if (result != null) {
//       usersRepository.put(result);
//     }
//   }
// }

// class UsersPage extends UI {
//   @override
//   Widget build(BuildContext context) {
//     return FScaffold(
//       header: FHeader.nested(
//         title: 'Users'.text(),
//         prefixActions: [FHeaderAction.back(onPress: _users.back)],
//         suffixActions: [
//           FHeaderAction(
//             icon: FIcon(FAssets.icons.creativeCommons),
//             onPress: _users.createNewUser,
//           ),
//         ],
//       ),
//       content:
//           FTileGroup.builder(
//             label: 'Users'.text(),
//             maxHeight: 500,
//             divider: FTileDivider.full,
//             count: _users.users.length,
//             tileBuilder: (context, index) {
//               final user = _users.users.elementAt(index);
//               return FTile(
//                 title: FBadge(label: user.name.text()),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [user.email.text(), user.password.text()],
//                 ),
//                 suffixIcon: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FButton.icon(
//                       onPress: () {
//                         _users.login(user);
//                       },
//                       child: FIcon(FAssets.icons.logIn),
//                       style: FButtonStyle.primary,
//                     ),
//                     SizedBox(width: 4),
//                     FButton.icon(
//                       onPress: () {
//                         _users.remove(user);
//                       },
//                       child: FIcon(FAssets.icons.delete),
//                       style: FButtonStyle.destructive,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ).pad(),
//     );
//   }
// }
