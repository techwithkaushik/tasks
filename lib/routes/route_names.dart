import 'package:get/get.dart';
import 'package:tasks/pages/add_edit_task.dart';
import 'package:tasks/pages/splash_page.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';

class RouteNames {
  static const String _initial = "/";
  static const String _loginPage = "/login-page";
  static const String _homePage = "/home-page";
  static const String _addEditTaskPage = "/add-edit-task-page";

  static String getInitial() => _initial;
  static String getLoginPage() => _loginPage;
  static String getHomePage() => _homePage;
  static String getAddEditTaskPage() => _addEditTaskPage;

  static List<GetPage> routes = [
    GetPage(name: _initial, page: () => SplashPage()),
    GetPage(name: _homePage, page: () => HomePage()),
    GetPage(name: _loginPage, page: () => LoginPage()),
    GetPage(name: _addEditTaskPage, page: () => AddEditTaskPage()),
  ];
}
