import 'package:eye/domain/api/users.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/domain/models/subscription_type.dart';
import 'package:eye/main.dart';
import 'package:yaru/yaru.dart';

// class UserProfileBloc {
//   // late final user = usersRepository.item;
//   // late final name = usersRepository.name;
//   // late final email = usersRepository.email;
//   // late final password = usersRepository.password;
//   // SubscriptionType get type => user().type;
//   // void deleteProgress() => usersRepository.progress();

//   // void deleteUser() {
//   //   usersRepository.remove(user().id);
//   //   navigator.toAndRemoveUntil(LoginPage());
//   // }
// }

final isObscuredRM = RM.inject<bool>(() => true);

class UserProfilePage extends UI {
  static const route = '/user_profile';
  const UserProfilePage({super.key});

  AppUser get user => safeUser!;

  @override
  Widget build(BuildContext context) {
    if (safeUser == null)
      return const Center(child: YaruCircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: user.name,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {},
            ),
            TextFormField(
              initialValue: user.email,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {},
            ),
            TextFormField(
              initialValue: user.password,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () => isObscuredRM.toggle(),
                  icon: Icon(
                    isObscuredRM.state
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
              onChanged: (value) {},
              obscureText: isObscuredRM.state,
            ),
            DropdownButtonFormField<SubscriptionType>(
              initialValue: user.type,
              decoration: const InputDecoration(labelText: 'Subscription'),
              items: SubscriptionType.values
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  users.put(user..type = v);
                }
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: user.dark,
              onChanged: users.loading
                  ? null
                  : (_) async {
                      if (user.dark) {
                        await users.put(user..dark = false);
                      } else {
                        await users.put(user..dark = true);
                      }
                    },
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: users.loading
                  ? null
                  : () async {
                      await users.remove(user.id);
                      authenticationRM.state = null;
                    },
              label: Text('DELETE USER'),
              icon: Icon(Icons.delete),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizHistory extends UI {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// class UserProfilePage extends UI {
//   const UserProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           spacing: 16,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 label: 'NAME'.text(),
//               ),
//               // initialValue: _userProfile.name(),
//               // onChanged: _userProfile.name,
//               // description: _userProfile.email.text(),
//             ),
//             // FLabel(
//             //   axis: Axis.vertical,
//             //   label: 'SUBSCRIPTIONS'.text(),
//             //   child: FButton(
//             //     prefix: Icon(Icons.square),
//             //     label: _userProfile.type.displayName.text(),
//             //     onPress: () => router.to(SubscriptionPage.route),
//             //   ),
//             //   description: 'Go to subscriptions page.'.text(),
//             // ),
//             // FLabel(
//             //   axis: Axis.vertical,
//             //   label: 'DELETE PROGRESS'.text(),
//             //   child: FButton(
//             //     style: FButtonStyle.destructive,
//             //     onPress: _userProfile.deleteProgress,
//             //     label: 'DELETE PROGRESS'.text(),
//             //   ),
//             //   description: 'This action is irreversible.'.text(),
//             // ),
//             // FLabel(
//             //   axis: Axis.vertical,
//             //   label: 'DELETE USER'.text(),
//             //   child: FButton(
//             //     style: FButtonStyle.destructive,
//             //     onPress: _userProfile.deleteUser,
//             //     label: 'DELETE USER'.text(),
//             //   ),
//             //   description: _deleteAction.text(),
//             // ),
//           ],
//         ).pad(),
//       ),
//     );
//   }
// }

// ignore: unused_element
const _deleteAction =
    ''
    'This action will permanently '
    'delete your account and '
    'all your progress.';
