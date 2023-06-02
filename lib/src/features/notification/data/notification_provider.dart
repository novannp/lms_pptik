import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';
import 'package:lms_pptik/src/features/http/provider/http_provider.dart';
import 'package:lms_pptik/src/models/notification_model.dart';

final notifiedProvider = StateProvider((ref) => true);

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final client = ref.watch(httpProvider);
  return NotificationRepository(client);
});

class NotificationRepository {
  final IOClient client;
  NotificationRepository(this.client);

  List<NotificationModel> listNotifications = [];
  Future<List<NotificationModel>> getAllNotifications(
      String token, int userId) async {
    String unread =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_message_get_messages&moodlewsrestformat=json&useridto=$userId&read=0";
    String read =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_message_get_messages&moodlewsrestformat=json&useridto=$userId&read=1";
    Uri urlUnread = Uri.parse(unread);
    Uri urlRead = Uri.parse(read);
    final response = await client.get(urlUnread);
    final response2 = await client.get(urlRead);

    if (response.statusCode == 200 && response2.statusCode == 200) {
      final result = jsonDecode(response.body)['messages'] as List;
      final result2 = jsonDecode(response2.body)['messages'] as List;
      if (result.isEmpty && result2.isEmpty) {
        return <NotificationModel>[];
      }
      final unreadResult =
          result.map((e) => NotificationModel.fromJson(e)).toList();
      final readResult =
          result2.map((e) => NotificationModel.fromJson(e)).toList();
      listNotifications = [...unreadResult, ...readResult];

      listNotifications
          .sort((a, b) => b.timecreated!.compareTo(a.timecreated!));
      return listNotifications;
    } else {
      throw Exception();
    }
  }
}
