import 'package:eye/domain/api/users.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/main.dart';
import 'package:manager/extensions.dart';

extension on UsersPage {
  void createNewUser() async {
    users.put(
      AppUser(),
    );
  }
}

class UsersPage extends UI {
  static const route = '/users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'SuperUser'.text(),
        leading: IconButton(
          onPressed: () {
            authenticationRM.state = null;
          },
          icon: Icon(Icons.logout),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.new_label),
            onPressed: createNewUser,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        itemCount: users.state.length,
        itemBuilder: (context, index) {
          final user = users.state.elementAt(index);
          return ListTile(
            title: user.name.text(),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [user.email.text(), user.password.text()],
            ),
            leading: IconButton.outlined(
              onPressed: () {},
              icon: Icon(Icons.login),
            ),
            trailing: IconButton.filledTonal(
              onPressed: users.loading ? null : () => users.remove(user.id),
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          );
        },
      ).pad(),
    );
  }
}
