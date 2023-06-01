import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_pptik/src/features/storage/provider/storage_provider.dart';

import '../../features/auth/provider/auth_notifier.dart';
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
      ref.watch(storageProvider).readAll().then((value) {
        if (value['token'] == null) {
          GoRouter.of(context).pushReplacementNamed(AppRoutes.login);
        } else {
          ref
              .watch(authNotifierProvider.notifier)
              .login(value['username'], value['password']);
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
            SvgPicture.asset(
              'assets/icons/logo.svg',
              width: 200,
            ),
            Loading()
          ],
        ),
      ),
    );
  }
}
