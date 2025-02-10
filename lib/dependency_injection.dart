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

abstract class Bloc {
  CategoriesRepository get categoriesRepository => _categories_;
  NavigationRepository get navigation => _navigation_;
  LoginRegisterRepository get loginRegisterRepository => _login_register_;
  UsersRepository get usersRepository => _users_;
  QuizzesRepository get quizzesRepository => _quizzes_;
  QuizTakingRepository get quizTakingRepository => _quizTaking_;
  late final back = navigation.back;

  scopedTo<T>(Widget page, {T? data}) => navigation.to(page);

  late final toAndRemoveUntil = navigation.toAndRemoveUntil;
  late final to = navigation.to;
}

abstract class UI extends ReactiveStatelessWidget {
  const UI({super.key});
}
