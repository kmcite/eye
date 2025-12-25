import 'package:eye/domain/api/users.dart';
import 'package:eye/features/auth/authentication_state.dart';
import 'package:eye/features/auth/login.dart';
import 'package:eye/features/auth/register.dart';
import 'package:eye/features/user/users.dart';
import 'package:eye/utils/api.dart';
import 'package:eye/main.dart';
import 'package:eye/utils/router.dart';

final authTabRM = RM.injectTabPageView(length: 2);

class AutheticationPage extends UI {
  static String route = '/login';
  const AutheticationPage({super.key});

  @override
  void didMountWidget(BuildContext context) {
    super.didMountWidget(context);
    loadingRM.onChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return OnTabPageViewBuilder(
      listenTo: authTabRM,
      builder: (index) => Scaffold(
        appBar: AppBar(
          title: Text('Authentication'),
          bottom: TabBar(
            controller: authTabRM.tabController,
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
                controller: authTabRM.tabController,
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

final appLogoAnimation = RM.injectAnimation(
  duration: Duration(milliseconds: 1800),
  shouldReverseRepeats: true,
  onInitialized: (_) {
    print('STARTED');
  },
  endAnimationListener: () {
    print('ENDED');
  },
  shouldAutoStart: true,
  repeats: 10,
);

class AppLogo extends UI {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        authenticationRM.state = -1;
        router.to(UsersPage.route);
      },
      child: SizedBox.square(
        dimension: 100,
        child: OnAnimationBuilder(
          listenTo: appLogoAnimation,
          builder: (animate) {
            return Transform.rotate(
              angle: animate.fromTween(
                (currentValue) => Tween(begin: 0, end: 2 * 3.14),
              )!,
              child: Icon(
                Icons.remove_red_eye,

                size: animate.fromTween(
                  (cv) => Tween(begin: 100, end: 80),
                  'size',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
