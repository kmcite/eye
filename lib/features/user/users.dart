import 'package:eye/business/users.dart';
import 'package:eye/domain/models/app_user.dart';
import 'package:eye/features/auth/authentication_state.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/db.dart';

extension on UsersPage {
  void createNewUser() async {
    put(AppUser());
  }
}

class UsersPage extends UI {
  static const route = '/users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SuperUser'),
        leading: IconButton(
          onPressed: () => logout(),
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
        itemCount: users().length,
        itemBuilder: (context, index) {
          final user = users().elementAt(index);
          return ListTile(
            title: Text(user.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Text(user.email), Text(user.password)],
            ),
            leading: IconButton.outlined(
              onPressed: () {},
              icon: Icon(Icons.login),
            ),
            trailing: IconButton.filledTonal(
              onPressed: () => remove<AppUser>(user.id),
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
