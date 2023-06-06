import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/features/auth/data/auth_repository.dart';
import 'package:lms_pptik/src/features/badge/provider/get_all_badges.dart';
import 'package:lms_pptik/src/features/calendar/data/calendar_repository.dart';
import 'package:lms_pptik/src/features/calendar/provider/all_events_provider.dart';
import 'package:lms_pptik/src/features/chat/provider/all_conversations.dart';
import 'package:lms_pptik/src/features/chat/provider/conversation_by_id.dart';
import 'package:lms_pptik/src/features/notification/provider/user_notification.dart';
import 'package:lms_pptik/src/features/user/provider/user_provider.dart';
import 'package:lms_pptik/src/views/screens/main_screen.dart';

import '../../notification/data/notification_provider.dart';
import '../../notification/provider/notification_settings.dart';
import '../../storage/provider/storage_provider.dart';
import '../../storage/service/secure_storage_service.dart';

final loadingStateProvider = StateProvider<bool>((ref) => false);

class AuthNotifier extends StateNotifier<String> {
  AuthNotifier({
    required this.ref,
    required this.auth,
    required this.storage,
  }) : super('');

  final AuthRepository auth;
  final SecureStorageService storage;
  final Ref ref;
  String? message;
  Future<String?> login(String username, String password) async {
    try {
      ref.watch(loadingStateProvider.notifier).state = true;
      final result = await auth.login(username, password);

      ref.watch(loadingStateProvider.notifier).state = false;
      if (result['token'] != null) {
        final String token = result['token'];
        storage.write('token', token);
        storage.write('username', username);
        storage.write('password', password);
        message = 'success';
        return message;
      } else {
        message = 'Akun tidak valid, silahkan coba lagi';
        return message;
      }
    } on SocketException {
      message = 'Silahkan periksa koneksi internet';

      ref.watch(loadingStateProvider.notifier).state = false;
      return message;
    }
  }

  Future logout() async {
    await storage.deleteAll();
    ref.invalidate(authNotifierProvider);
    ref.invalidate(userProvider);
    ref.invalidate(indexProvider);
    ref.invalidate(notifiedProvider);
    ref.invalidate(allConversationsProvider);
    ref.invalidate(getAllBadgesProvider);
    ref.invalidate(allEventProvider);
    ref.invalidate(conversationIdProvider);
    ref.invalidate(notificationSettingsProvider);
    ref.invalidate(userNotificationProvider);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, String>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  final storage = ref.watch(storageProvider);
  return AuthNotifier(auth: auth, storage: storage, ref: ref);
});
