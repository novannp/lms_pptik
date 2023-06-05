import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/conversation_model.dart';
import '../../storage/provider/storage_provider.dart';
import '../data/chat_repository.dart';

final selfConversationProvider = FutureProvider.family<ConversationModel, int>(
  (ref, userId) async {
    final storage = ref.watch(storageProvider);
    final token = await storage.read('token');
    return ref.watch(chatRepositoryProvider).getSelfConversation(token, userId);
  },
);
