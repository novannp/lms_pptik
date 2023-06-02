import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_pptik/src/models/course_model.dart';
import 'package:lms_pptik/src/views/screens/login_screen.dart';
import 'package:lms_pptik/src/views/screens/main_screen.dart';

import '../models/module.dart';
import '../models/notification_model.dart';
import '../views/screens/course/course_detail.dart';
import '../views/screens/course/materi_detail.dart';
import '../views/screens/notification/notification_detail.dart';
import '../views/screens/notification/notification_screen.dart';
import '../views/screens/recent_course_screen.dart';
import '../views/screens/search_screen.dart';
import '../views/screens/splash_screen.dart';

class AppRoutes {
  static const String login = 'login';
  static const String splash = '/splash';
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

  static Page _searchScreenBuilder(BuildContext context, GoRouterState state) {
    return const MaterialPage(
      child: SearchScreen(),
    );
  }

  static Page _recentCoursesScreenBuilder(
      BuildContext context, GoRouterState state) {
    return const MaterialPage(child: RecentCourseScreen());
  }

  static Page _notificationScreenBuilder(
      BuildContext context, GoRouterState state) {
    final userId = state.extra as int;
    return MaterialPage(child: NotificationScreen(id: userId));
  }

  static Page _materiDetailScreenBuilder(
      BuildContext context, GoRouterState state) {
    final data = state.extra as MateriModel;
    return MaterialPage(
        child: MateriDetailScreen(
      data: data,
    ));
  }

  static GoRouter goRouter = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routerNeglect: true,
    routes: [
      GoRoute(
        name: 'splash',
        path: splash,
        pageBuilder: _splashScreenBuilder,
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: _loginScreenBuilder,
      ),
      GoRoute(
        path: '/main',
        name: main,
        pageBuilder: _mainScreenBuilder,
        routes: [
          GoRoute(
              path: 'notifications',
              pageBuilder: _notificationScreenBuilder,
              name: 'notification',
              routes: [
                GoRoute(
                  path: 'detail_notification',
                  pageBuilder: (context, state) {
                    final data = state.extra as NotificationModel;
                    return MaterialPage(child: NotificationDetailScreen(data));
                  },
                  name: 'detail_notification',
                ),
              ]),
          GoRoute(
            path: 'recent_course',
            pageBuilder: _recentCoursesScreenBuilder,
            name: 'recent_course',
          ),
          GoRoute(
              path: 'course',
              pageBuilder: _courseDetailScreenBuilder,
              name: 'course_detail',
              routes: [
                GoRoute(
                  path: 'materi',
                  pageBuilder: _materiDetailScreenBuilder,
                  name: 'materi_detail',
                ),
              ]),
          GoRoute(
            path: 'search',
            pageBuilder: _searchScreenBuilder,
            name: 'search',
          )
        ],
      )
    ],
  );
}
