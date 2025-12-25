// app_routes.dart
import 'package:eye/domain/api/users.dart';
import 'package:eye/domain/models/question.dart';
import 'package:eye/features/categories/categories.dart';
import 'package:eye/features/home/home.dart';
import 'package:eye/features/auth/authentication.dart';
import 'package:eye/features/question_editor/question_editor.dart';
import 'package:eye/features/questions_page.dart';
import 'package:eye/features/quizzes/quiz/quiz_page.dart';
import 'package:eye/features/quizzes/quiz_taking.dart';
import 'package:eye/features/quizzes/quizzes_page.dart';
import 'package:eye/features/settings_page.dart';
import 'package:eye/features/subscription_page.dart';
import 'package:eye/features/user/user_profile.dart';
import 'package:eye/features/user/users.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// ─────────────────────────────────────────────────────────────
/// ROUTER & NAVIGATOR
/// ─────────────────────────────────────────────────────────────

// ignore: deprecated_member_use
final router = RM.injectNavigator(
  transitionsBuilder: RM.transitions.leftToRight(),
  routes: {
    /// AUTHENTICATION
    AutheticationPage.route: (_) => RouteWidget(
      builder: (_) => AutheticationPage(),
      transitionsBuilder: RM.transitions.none(),
    ),
    UsersPage.route: (_) => UsersPage(),

    /// HOME
    HomePage.route: (_) => RouteWidget(
      builder: (_) => HomePage(),
      transitionsBuilder: RM.transitions.none(),
    ),

    /// FEATURES
    CategoriesPage.route: (_) => CategoriesPage(),
    QuestionsPage.route: (_) => QuestionsPage(),
    QuestionPage.route: (data) => localQuestionRM.inherited(
      builder: (context) => QuestionPage(),
      stateOverride: () => data.arguments as Question,
    ),

    /// QUIZZING
    QuizzesPage.route: (_) => QuizzesPage(),
    QuizPage.route: (_) => QuizPage(),
    QuizTakingPage.route: (_) => QuizTakingPage(),

    /// SETTINGS
    SettingsPage.route: (_) => SettingsPage(),
    UserProfilePage.route: (_) => UserProfilePage(),
    SubscriptionPage.route: (_) => SubscriptionPage(),
  },
  onNavigate: (data) {
    final location = data.location;
    if (!authenticated && location != AutheticationPage.route) {
      // User is not signed and tries to enter the app without signing in
      // Redirect the user to the sign in page
      return data.redirectTo(AutheticationPage.route);
    }

    if (authenticated && location == AutheticationPage.route) {
      // User is signed and tries to enter the sign in page
      // Redirect the user to the home page
      return data.redirectTo(HomePage.route);
    }
    return null;
  },
  debugPrintWhenRouted: true,
  onNavigateBack: (data) {
    return data != null;
  },
);
