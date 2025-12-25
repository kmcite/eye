// import 'package:eye/domain/api/users_repository.dart';
// import 'package:eye/domain/models/subscription_type.dart';
// import 'package:eye/domain/models/app_user.dart';
// import 'package:eye/domain/api/navigation_repository.dart';
// import 'package:eye/main.dart';

// import '../../domain/models/user_progress.dart';

// final _newUser = NewUserBloc();

// class NewUserBloc {
//   final userRM = RM.inject(() => AppUser());
//   AppUser user([AppUser? value]) {
//     if (value != null) {
//       userRM
//         ..state = value
//         ..notify();
//     }
//     return userRM.state;
//   }

//   Modifier<String> name = usersRepository.name;
//   Modifier<String> email = usersRepository.email;
//   Modifier<String> password = usersRepository.password;
//   Modifier<UserProgress?> progress = usersRepository.progress;

//   SubscriptionType type([SubscriptionType? value]) {
//     if (value != null) {
//       user(user()..type = value);
//     }
//     return user().type;
//   }

//   late var back = navigator.back;
//   void save() {
//     back(user());
//   }
// }

// class NewUserDialog extends UI {
//   @override
//   Widget build(BuildContext context) {
//     return FDialog(
//       title: 'New User Dialog'.text(),
//       body: Column(
//         children: [
//           FTextField(
//             label: 'Name'.text(),
//             initialValue: _newUser.name(),
//             onChange: _newUser.name,
//           ),
//           FTextField(
//             label: 'Email'.text(),
//             initialValue: _newUser.email(),
//             onChange: _newUser.email,
//           ),
//           FTextField(
//             label: 'Password'.text(),
//             initialValue: _newUser.password(),
//             onChange: _newUser.password,
//           ),
//           FTileGroup(
//             label: 'Subscription'.text(),
//             maxHeight: 100,
//             divider: FTileDivider.full,
//             children:
//                 SubscriptionType.values.map((type) {
//                   return FTile(
//                     suffixIcon:
//                         type == _newUser.type()
//                             ? FIcon(FAssets.icons.check)
//                             : null,
//                     title: type.displayName.text(),
//                     onPress: () => _newUser.user(),
//                   );
//                 }).toList(),
//           ),
//         ],
//       ),
//       actions: [
//         FButton(onPress: () => _newUser.save(), label: 'Save'.text()),
//         FButton(onPress: () => _newUser.back(), label: 'Cancel'.text()),
//       ],
//     );
//   }
// }
