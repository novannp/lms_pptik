import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/features/chat/data/chat_repository.dart';

import '../../../models/conversation_model.dart';
import '../../storage/provider/storage_provider.dart';
import 'conversation_by_id.dart';

class ChatParam {
  final int userId;
  final int conversationId;

  ChatParam(this.userId, this.conversationId);
}

final sendMessageProvider =
    FutureProvider.family<Messages, String>((ref, message) async {
  final storage = ref.watch(storageProvider);
  final token = await storage.read('token');
  final conversationId = ref.read(conversationIdProvider);

  return ref
      .watch(chatRepositoryProvider)
      .sendMessage(token, conversationId, message);
});
