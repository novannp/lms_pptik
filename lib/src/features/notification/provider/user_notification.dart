import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/notification_model.dart';
import '../../storage/provider/storage_provider.dart';
import '../data/notification_provider.dart';

final userNotificationProvider =
    FutureProvider.family<List<NotificationModel>, int>((ref, userId) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  return ref
      .watch(notificationRepositoryProvider)
      .getAllNotifications(token, userId);
});

