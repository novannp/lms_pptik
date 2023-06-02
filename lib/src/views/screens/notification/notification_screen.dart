import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_pptik/src/extentions/string_extensions.dart';
import '../../../extentions/int_extensions.dart';

import '../../../features/notification/provider/user_notification.dart';
import '../../components/loading_widget.dart';

class NotificationScreen extends ConsumerWidget {
  final int? id;
  const NotificationScreen({super.key, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(userNotificationProvider(id!));
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Notifikasi'),
      ),
      child: notifications.when(data: (data) {
        return ListView.separated(
          separatorBuilder: (context, index) => Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return CupertinoListTile(
              padding: const EdgeInsets.all(14),
              onTap: () {
                GoRouter.of(context).pushNamed(
                  'detail_notification',
                  extra: data[index],
                );
              },
              backgroundColor: CupertinoColors.systemBackground,
              title: Text(data[index].subject!),
              subtitle: Text(
                  data[index].timecreated!.toDate().toString().formatDate()),
              //type assign or insight
              leading: data[index].eventtype == 'assign_notification'
                  ? const Icon(
                      CupertinoIcons.tray_fill,
                    )
                  : const Icon(
                      CupertinoIcons.bell_circle,
                    ),
              //unread indicator
              trailing: data[index].timeread == null
                  ? const Icon(
                      CupertinoIcons.circle_fill,
                      color: CupertinoColors.systemBlue,
                      size: 12,
                    )
                  : null,
            );
          },
        );
      }, error: (error, stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      }, loading: () {
        return Loading();
      }),
    );
  }
}
