import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/features/chat/data/chat_repository.dart';
import 'package:lms_pptik/src/features/storage/provider/storage_provider.dart';

import '../../../models/chat_model.dart';

final conversationProvider =
    FutureProvider.family.autoDispose<ChatModel, int>((ref, userId) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  final chatRepository = ref.watch(chatRepositoryProvider);
  final conversationId = ref.watch(conversationIdProvider);
  return chatRepository.getConversationById(token, userId, conversationId);
});

final conversationIdProvider = StateProvider<int>((ref) {
  return 0;
});
