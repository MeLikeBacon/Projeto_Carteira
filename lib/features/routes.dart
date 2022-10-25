// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

import 'account/forgor_view.dart';
import 'account/login_view.dart';
import 'account/account_view.dart';
import 'account/signup_view.dart';
import 'admin/admin_view.dart';
import 'admin/manage_view.dart';
import 'admin/userlist_view.dart';
import 'home/home_view.dart';
import 'movement/movs_view.dart';
import 'movement/pdf_view.dart';
import 'movement/plots_view.dart';
import 'movement/search_view.dart';

class Routes {
  static const initial = '/';
  static const home_view = '/home';
  static const login_view = '/login';
  static const signup_view = '/signup';
  static const movs_view = '/movs';
  static const search_view = '/search';
  static const pdf_view = '/pdf';
  static const account_view = '/account';
  static const forgor_view = '/forgor';
  static const plots_view = '/plots';
  static const manage_view = '/manage';
  static const userlist_view = '/userlist';
  static const adm_view = '/adm';

  static Map<String, Widget Function(BuildContext)> routes = {
    home_view: (BuildContext context) => HomeView(),
    login_view: (BuildContext context) => LoginView(),
    signup_view: (BuildContext context) => SignUpView(),
    movs_view: (BuildContext context) => MovsView(),
    search_view: (BuildContext context) => SearchView(),
    pdf_view: (BuildContext context) => PDFView(),
    account_view: (BuildContext context) => AccountView(),
    forgor_view: (BuildContext context) => ForgorView(),
    plots_view: (BuildContext context) => PlotsView(),
    manage_view: (BuildContext context) => ManageView(),
    userlist_view: (BuildContext context) => UserListView(),
    adm_view: (BuildContext context) => AdminView(),
  };

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
