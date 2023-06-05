import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/features/chat/data/chat_repository.dart';

import '../../../models/conversation_model.dart';
import '../../storage/provider/storage_provider.dart';

final allConversationsProvider =
    FutureProvider.family<List<ConversationModel>, int>(
  (ref, userId) async {
    final storage = ref.watch(storageProvider);
    final token = await storage.read('token');
    return ref.watch(chatRepositoryProvider).getAllConversations(token, userId);
  },
);
