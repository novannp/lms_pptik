import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/io_client.dart';

import '../../../models/chat_model.dart';
import '../../../models/conversation_model.dart';
import '../../../utills/endpoints.dart';
import '../../http/provider/http_provider.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(httpProvider));
});

class ChatRepository {
  final IOClient client;

  ChatRepository(this.client);

  Future<ConversationModel> getSelfConversation(
      String token, int userid) async {
    Uri url = Uri.https(
      Endpoints.baseUrl,
      Endpoints.rest,
      {
        'wstoken': token,
        'wsfunction': 'core_message_get_self_conversation',
        'moodlewsrestformat': 'json',
        'userid': userid,
      }.map((key, value) => MapEntry(key, value.toString())),
    );
    final response = await client.get(url);
    final result = jsonDecode(response.body);
    log(response.reasonPhrase!);
    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return ConversationModel();
      }
      return ConversationModel.fromJson(result);
    } else {
      throw Exception();
    }
  }

  Future<List<ConversationModel>> getAllConversations(
      String token, int userid) async {
    Uri url = Uri.https(
      Endpoints.baseUrl,
      Endpoints.rest,
      {
        'wstoken': token,
        'wsfunction': 'core_message_get_conversations',
        'moodlewsrestformat': 'json',
        'userid': userid,
      }.map((key, value) => MapEntry(key, value.toString())),
    );
    final response = await client.get(url);
    final result = jsonDecode(response.body)['conversations'];

    if (response.statusCode == 200) {
      if (result.isEmpty) {
        return <ConversationModel>[];
      }
      final conversations = result
          .map<ConversationModel>((e) => ConversationModel.fromJson(e))
          .toList();
      inspect(conversations);
      return conversations;
    } else {
      throw Exception();
    }
  }

  Future<ChatModel> getConversationById(
      String token, int userid, int conversationId) async {
    Uri url = Uri.https(
      Endpoints.baseUrl,
      Endpoints.rest,
      {
        'wstoken': token,
        'wsfunction': 'core_message_get_conversation_messages',
        'moodlewsrestformat': 'json',
        'currentuserid': userid,
        'convid': conversationId,
      }.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await client.get(url);
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final conversation = ChatModel.fromJson(result);
      inspect(conversation);
      return conversation;
    } else {
      throw Exception();
    }
  }

  Future<Messages> sendMessage(
      String token, int conversationId, String message) async {
    Uri url = Uri.https(
      Endpoints.baseUrl,
      Endpoints.rest,
      {
        'wstoken': token,
        'wsfunction': 'core_message_send_messages_to_conversation',
        'moodlewsrestformat': 'json',
        'conversationid': conversationId,
        'messages[0][text]': message,
        'messages[0][textformat]': 1
      }.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await client.get(url);
    final result = jsonDecode(response.body);
    log(url.toString());
    print(result);
    if (response.statusCode == 200) {
      final message = Messages.fromJson(result[0]);
      log('Pesan berhasil dikirim');
      print(result);
      return message;
    } else {
      throw Exception();
    }
  }
}
