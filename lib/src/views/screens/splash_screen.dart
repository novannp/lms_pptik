import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_pptik/src/features/storage/provider/storage_provider.dart';

import '../../routes/app_routes.dart';
import '../components/loading_widget.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      ref.watch(storageProvider).read('token').then((value) {
        if (value == null) {
          GoRouter.of(context).pushReplacementNamed(AppRoutes.login);
        } else {
          GoRouter.of(context).pushReplacementNamed(AppRoutes.main);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              style: FlutterLogoStyle.stacked,
              size: 70,
            ),
            Loading()
          ],
        ),
      ),
    );
  }
}
