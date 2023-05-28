import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/features/storage/provider/storage_provider.dart';

import '../../../models/user_model.dart';
import '../data/user_repository.dart';

final userProvider = FutureProvider.autoDispose<UserModel>((ref) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  final username = await storage.read('username');
  return ref.watch(userRepositoryProvider).getUser(username, token);
});
