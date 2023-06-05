import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Pengaturan'),
        previousPageTitle: 'Profil',
      ),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoListSection(
              children: [
                CupertinoListTile(
                  onTap: () {
                    GoRouter.of(context).pushNamed('notification_settings');
                  },
                  leading: const Icon(CupertinoIcons.bell),
                  title: const Text('Notifikasi'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
