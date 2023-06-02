import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: CupertinoColors.systemGroupedBackground,
    statusBarIconBrightness: Brightness.dark,
  ));

  // NOTIFIKASI
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'welcome',
        playSound: true,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/welcome',
        channelName: 'Welcome Notification',
        channelDescription: 'notification for who logged in',
      ),
    ],
    debug: true,
  );

  runApp(const ProviderScope(child: LmsApp()));
}

class LmsApp extends StatelessWidget {
  const LmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('id'),
      ],
      locale: const Locale('id'),
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
        applyThemeToAll: true,
        textTheme: CupertinoTextThemeData(
          tabLabelTextStyle: TextStyle(fontFamily: 'SF-Pro', fontSize: 12),
          pickerTextStyle: TextStyle(
            fontFamily: 'SF-Pro',
            color: CupertinoColors.activeBlue,
          ),
          navLargeTitleTextStyle: TextStyle(
            fontFamily: 'SF-Pro',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textStyle: TextStyle(
            fontFamily: 'SF-Pro',
            color: Colors.black,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'LMS PPTIK',
      routeInformationParser: AppRoutes.goRouter.routeInformationParser,
      routeInformationProvider: AppRoutes.goRouter.routeInformationProvider,
      routerDelegate: AppRoutes.goRouter.routerDelegate,
    );
  }
}
