import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/views/home_view.dart';
import 'package:projeto_carteira/features/views/login_view.dart';
import 'package:projeto_carteira/features/views/movs_view.dart';
import 'package:projeto_carteira/features/views/signup_view.dart';

import 'views/account_view.dart';

class Routes {
  static const initial = '/';
  static const home_view = '/home';
  static const login_view = '/login';
  static const signup_view = '/signup';
  static const movs_view = '/movs';
  static const account_view = '/account';

  static Map<String, Widget Function(BuildContext)> routes = {
    home_view: (BuildContext context) => HomeView(),
    login_view: (BuildContext context) => LoginView(),
    signup_view: (BuildContext context) => SignUpView(),
    movs_view: (BuildContext context) => MovsView(),
    account_view: (BuildContext context) => AccountView(),
  };
}
