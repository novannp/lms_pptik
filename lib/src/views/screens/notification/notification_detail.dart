import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
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
            title: Text(notificationModel.subject!),
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
                child: HtmlWidget(
                  notificationModel.fullmessagehtml!,
                  customStylesBuilder: (element) {
                    if (element.localName == "hr") {
                      return {
                        'border': '.5px solid #eeeeee',
                        'margin': '20px 0px'
                      };
                    } else {
                      return {};
                    }
                  },
                  textStyle: CupertinoTheme.of(context).textTheme.textStyle,
                  onTapUrl: (value) {
                    return false;
                  },
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
