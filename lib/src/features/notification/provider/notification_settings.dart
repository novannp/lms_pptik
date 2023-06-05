import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/notification_settings_model.dart';
import '../../storage/provider/storage_provider.dart';
import '../data/notification_provider.dart';

final notificationSettingsProvider =
    FutureProvider<NotificationSettingsModel>((ref) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  return ref
      .watch(notificationRepositoryProvider)
      .getNotificationSettings(token);
});
