import 'package:eye/business/users.dart';
import 'package:eye/features/auth/authentication.dart';
import 'package:eye/features/auth/authentication_state.dart';
import 'package:eye/features/categories/categories.dart';
import 'package:eye/features/questions_page.dart';
import 'package:eye/features/quizzes/quizzes_page.dart';
import 'package:eye/features/settings_page.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/navigator.dart';

const iconSize = 80.0;

class AppDrawer extends UI {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo and Name
              CircleAvatar(
                child: Icon(
                  Icons.remove_red_eye,
                  size: iconSize / 1.2,
                ),
                radius: iconSize,
              ),
              const SizedBox(height: 16),
              Text(
                'Eye',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 16),
              if (user() != null)
                Column(
                  children: [
                    Text(
                      user()!.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user()!.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text(
                      'Guest User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Not logged in',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

              const Divider(height: 32),

              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                },
              ),

              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Categories'),
                onTap: () {
                  router.to(CategoriesPage.route);
                  Navigator.pop(context); // Close drawer
                },
              ),

              ListTile(
                leading: Icon(Icons.file_copy),
                title: Text('Questions'),
                onTap: () {
                  router.to(QuestionsPage.route);
                  Navigator.pop(context); // Close drawer
                },
              ),

              ListTile(
                leading: Icon(Icons.quiz),
                title: Text('Quizzes'),
                onTap: () {
                  router.to(QuizzesPage.route);
                  Navigator.pop(context); // Close drawer
                },
              ),

              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  router.to(SettingsPage.route);
                  Navigator.pop(context); // Close drawer
                },
              ),

              const Spacer(),
              if (authenticated())
                ElevatedButton.icon(
                  label: Text('Logout'),
                  onPressed: () => logout(),
                  icon: Icon(Icons.logout),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    router.to(AutheticationPage.route);
                    Navigator.pop(context); // Close drawer
                  },
                  child: Text('Login'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
