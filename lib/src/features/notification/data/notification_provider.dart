import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';
import 'package:lms_pptik/src/features/http/provider/http_provider.dart';
import 'package:lms_pptik/src/models/notification_model.dart';

import '../../../models/notification_settings_model.dart';
import '../../../utills/endpoints.dart';

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
    Uri urlUnread = Uri.https(
      Endpoints.baseUrl,
      Endpoints.rest,
      {
        'wstoken': token,
        'wsfunction': 'core_message_get_messages',
        'moodlewsrestformat': 'json',
        'useridto': userId.toString(),
        'read': 0,
      }.map((key, value) => MapEntry(key, value.toString())),
    );
    Uri urlRead = Uri.https(
      Endpoints.baseUrl,
      Endpoints.rest,
      {
        'wstoken': token,
        'wsfunction': 'core_message_get_messages',
        'moodlewsrestformat': 'json',
        'useridto': userId.toString(),
        'read': 1,
      }.map((key, value) => MapEntry(key, value.toString())),
    );

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
      inspect(listNotifications);
      listNotifications
          .sort((a, b) => b.timecreated!.compareTo(a.timecreated!));
      listNotifications.removeWhere((element) =>
          element.notification == 0 || element.notification == null);
      return listNotifications;
    } else {
      throw Exception();
    }
  }

  Future<NotificationSettingsModel> getNotificationSettings(
      String token) async {
    String unread =
        "https://lms.pptik.id/webservice/rest/server.php/?wstoken=$token&wsfunction=core_message_get_user_notification_preferences&moodlewsrestformat=json";

    Uri urlUnread = Uri.parse(unread);
    final response = await client.get(urlUnread);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return NotificationSettingsModel.fromJson(result);
    } else {
      throw Exception();
    }
  }
}
