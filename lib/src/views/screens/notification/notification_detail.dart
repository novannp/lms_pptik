import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/extentions/int_extensions.dart';
import 'package:lms_pptik/src/extentions/string_extensions.dart';

import '../../../models/notification_model.dart';

class NotificationDetailScreen extends ConsumerWidget {
  const NotificationDetailScreen(this.notificationModel, {super.key});

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Detail Notifikasi'),
      ),
      child: SafeArea(
        child: Column(children: [
          CupertinoListTile(
            leading: notificationModel.eventtype == 'assign_notification'
                ? const Icon(
                    CupertinoIcons.tray_fill,
                  )
                : const Icon(
                    CupertinoIcons.bell_circle,
                  ),
            title: Text(notificationModel.subject ?? 'Tanpa subjek'),
            subtitle: Text(notificationModel.timecreated!
                .toDate()
                .toString()
                .formatDate()),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Html(
                  data: notificationModel.fullmessagehtml ??
                      notificationModel.text,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
