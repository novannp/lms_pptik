import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/features/auth/data/auth_repository.dart';
import 'package:lms_pptik/src/features/user/provider/user_provider.dart';
import 'package:lms_pptik/src/views/screens/main_screen.dart';

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
        message = 'success';
        return message;
      } else {
        message = 'Login tidak valid, silahkan coba lagi';
        return message;
      }
    } on SocketException {
      message = 'Periksa koneksi internet';
      return message;
    }
  }

  Future logout() async {
    await storage.deleteAll();
    ref.invalidate(authNotifierProvider);
    ref.invalidate(userProvider);
    ref.invalidate(indexProvider);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, String>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  final storage = ref.watch(storageProvider);
  return AuthNotifier(auth: auth, storage: storage, ref: ref);
});
