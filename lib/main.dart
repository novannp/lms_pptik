import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/routes/app_routes.dart';
import 'package:lms_pptik/src/views/themes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'src/views/screens/login_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const ProviderScope(child: LmsApp()));
}

class LmsApp extends StatelessWidget {
  const LmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => ClassicHeader(
        failedText: 'Gagal, silahkan periksa koneksi',
        refreshStyle: RefreshStyle.Behind,
        refreshingText: 'Memuat data',
        releaseText: 'Lepaskan',
        completeText: 'Selesai',
      ),
      child: MaterialApp.router(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
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
