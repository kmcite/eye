import 'package:eye/business/authentication_state.dart';
import 'package:eye/authentication/login.dart';
import 'package:eye/authentication/register.dart';
import 'package:eye/utils/ui.dart';
import 'package:flutter/material.dart';

class AutheticationPage extends StatelessWidget {
  const AutheticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Authentication'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Login'),
              Tab(text: 'Register'),
            ],
          ),
        ),

        body: Column(
          children: [
            AppLogo(),
            Expanded(
              child: TabBarView(
                children: [
                  LoginView(),
                  RegisterView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppLogo extends UI {
  @override
  Widget build(BuildContext context) {
    final authentication = authenticationSpark();
    return GestureDetector(
      onDoubleTap: () {
        authentication.bypassLogin();
      },
      child: SizedBox.square(
        dimension: 100,
        child: Icon(Icons.remove_red_eye, size: 80),
      ),
    );
  }
}
