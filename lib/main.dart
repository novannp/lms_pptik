import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/routes/app_routes.dart';
import 'package:lms_pptik/src/views/themes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
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
        soundSource: 'resouce://raw/welcome',
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
    return RefreshConfiguration(
      headerBuilder: () => const ClassicHeader(
        failedText: 'Gagal, silahkan periksa koneksi',
        refreshStyle: RefreshStyle.Behind,
        refreshingText: 'Memuat data',
        releaseText: 'Lepaskan',
        completeText: 'Selesai',
      ),
      child: MaterialApp.router(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          SfGlobalLocalizations.delegate
        ],
        supportedLocales: [
          Locale('id'),
        ],
        locale: const Locale('id'),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            elevation: 0,
          ),
          primaryColor: kPrimaryColor,
          fontFamily: 'Poppins',
        ),
        debugShowCheckedModeBanner: false,
        title: 'LMS PPTIK',
        routeInformationParser: AppRoutes.goRouter.routeInformationParser,
        routeInformationProvider: AppRoutes.goRouter.routeInformationProvider,
        routerDelegate: AppRoutes.goRouter.routerDelegate,
      ),
    );
  }
}
