import 'package:eye/questions/questions_repository.dart';
import 'package:eye/quiz_taking/quiz_taking.dart';

import 'authentication/login_register_repository.dart';
import 'categories/categories_repository.dart';
import 'authentication/users/users_repository.dart';
import 'main.dart';
import 'navigation/navigation_repository.dart';
import 'quizzes/quizzes_repository.dart';

final _categories_ = CategoriesRepository();
final _navigation_ = NavigationRepository();
final _login_register_ = LoginRegisterRepository();
final _users_ = UsersRepository();
final _quizzes_ = QuizzesRepository();
final _quizTaking_ = QuizTakingRepository();
final _questions_ = QuestionsRepository();

abstract class Bloc {
  CategoriesRepository get categoriesRepository => _categories_;
  LoginRegisterRepository get loginRegisterRepository => _login_register_;
  QuizzesRepository get quizzesRepository => _quizzes_;
  QuizTakingRepository get quizTakingRepository => _quizTaking_;
  QuestionsRepository get questionsRepository => _questions_;

  UsersRepository get usersRepository => _users_;
  NavigationRepository get navigation => _navigation_;
  late final toAndRemoveUntil = navigation.toAndRemoveUntil;
  late final to = navigation.to;
  late final back = navigation.back;
}

abstract class UI extends ReactiveStatelessWidget {
  const UI({super.key});
}
