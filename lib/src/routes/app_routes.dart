import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_pptik/src/models/course_model.dart';
import 'package:lms_pptik/src/views/screens/login_screen.dart';
import 'package:lms_pptik/src/views/screens/main_screen.dart';

import '../views/screens/course/course_detail.dart';
import '../views/screens/splash_screen.dart';

class AppRoutes {
  static const String login = 'login';
  static const String splash = '/';
  static const String main = 'main';

  static Page _splashScreenBuilder(BuildContext context, GoRouterState state) {
    return const MaterialPage(child: SplashScreen());
  }

  static Page _loginScreenBuilder(BuildContext context, GoRouterState state) {
    return const MaterialPage(child: LoginScreen());
  }

  static Page _mainScreenBuilder(BuildContext context, GoRouterState state) {
    return const MaterialPage(child: MainScreen());
  }

  static Page _courseDetailScreenBuilder(
      BuildContext context, GoRouterState state) {
    return MaterialPage(
        child: CourseDetail(
      state.extra as CourseModel,
    ));
  }

  static GoRouter goRouter = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: 'splash',
        path: splash,
        pageBuilder: _splashScreenBuilder,
        routes: [
          GoRoute(
            path: 'login',
            name: login,
            pageBuilder: _loginScreenBuilder,
          ),
          GoRoute(
              path: main,
              name: main,
              pageBuilder: _mainScreenBuilder,
              routes: [
                GoRoute(
                  path: 'course',
                  pageBuilder: _courseDetailScreenBuilder,
                  name: 'course_detail',
                )
              ])
        ],
      ),
    ],
  );
}