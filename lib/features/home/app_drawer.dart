import 'package:eye/domain/models/app_user.dart';
import 'package:eye/features/auth/authentication_state.dart';
import 'package:eye/main.dart';

const iconSize = 80.0;

// ignore: must_be_immutable
class AppDrawer extends UI {
  AppUser user = AppUser()
    ..name = 'Adn'
    ..email = 'adn@gmail.com';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 8,
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.remove_red_eye,
                  size: iconSize / 1.2,
                ),
                radius: iconSize,
              ),
              Text(
                'Eye',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              Text(user.name),
              Text(user.email),
              Divider(),
              Spacer(),
              ElevatedButton.icon(
                label: Text('Logout'),
                onPressed: () => logout(),
                icon: Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
