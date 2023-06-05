import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/features/notification/data/notification_plugin.dart';
import 'package:lms_pptik/src/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationPlugin().init();

  FirebaseMessaging.instance.getToken().then((value) {
    if (kDebugMode) {
      print('FCM Token: $value');
    }
  });

  FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    await NotificationPlugin().pushNotification(message);
  });

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: CupertinoColors.systemGroupedBackground,
    statusBarIconBrightness: Brightness.dark,
  ));

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
