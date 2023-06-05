import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/notification/provider/notification_settings.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifSettings = ref.watch(notificationSettingsProvider);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Notifikasi'),
        previousPageTitle: 'Pengaturan',
      ),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoListSection(
              children: [
                CupertinoListTile.notched(
                  title: const Text('Izinkan notifikasi'),
                  trailing: notifSettings.when(
                    data: (data) {
                      bool notif =
                          data.preferences.disableall == 1 ? false : true;
                      return CupertinoSwitch(
                          value: notif, onChanged: (value) {});
                    },
                    error: (error, stackTrace) {
                      return const Text('Error');
                    },
                    loading: () => const CupertinoActivityIndicator(),
                  ),
                ),
              ],
            ),
            CupertinoListSection(
              children: [
                CupertinoListTile(
                  title: const Text('Tipe Notifikasi'),
                  trailing: CupertinoButton(
                    child: const Row(
                      children: [
                        Text('Web'),
                        Icon(
                          CupertinoIcons.chevron_down,
                          size: 14,
                        )
                      ],
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              title: const Text('Tipe Notifikasi'),
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Web'),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Email'),
                                )
                              ],
                            );
                          });
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
