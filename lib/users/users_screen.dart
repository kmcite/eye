import 'package:eye/business/authentication_state.dart';
import 'package:flutter/material.dart';

// import 'package:eye/domain/models/app_user.dart';
// import 'package:eye/users/objectbox.dart';
import 'package:eye/business/users.dart';
import 'package:eye/utils/ui.dart';

extension on UsersPage {
  void createNewUser() async {
    // put(AppUser());
  }
}

class UsersPage extends UI {
  @override
  Widget build(BuildContext context) {
    final authentication = authenticationSpark();
    final users = usersSpark();
    return Scaffold(
      appBar: AppBar(
        title: Text('SuperUser'),
        leading: IconButton(
          onPressed: () {
            authentication.logout();
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
        itemCount: users.users.length,
        itemBuilder: (context, index) {
          final user = users.users.elementAt(index);
          return ListTile(
            title: Text(user.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Text(user.email), Text(user.username)],
            ),
            leading: IconButton.outlined(
              onPressed: () {},
              icon: Icon(Icons.login),
            ),
            trailing: IconButton.filledTonal(
              onPressed: () => users.remove(user.id),
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
