import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lms_pptik/src/extentions/int_extensions.dart';
import 'package:lms_pptik/src/features/chat/data/chat_repository.dart';
import 'package:lms_pptik/src/features/chat/provider/all_conversations.dart';

import '../../../features/chat/provider/conversation_by_id.dart';
import '../../../features/chat/provider/send_message.dart';
import '../../../features/storage/provider/storage_provider.dart';
import '../../../features/user/provider/user_provider.dart';
import '../../../models/conversation_model.dart';
import '../../../models/user_model.dart';
import '../../components/bubble_chat.dart';

final checkMessageProvider = StateProvider<bool>((ref) {
  return true;
});

final sendLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

class DetailChatScreen extends ConsumerStatefulWidget {
  const DetailChatScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailChatScreenState();
}

class _DetailChatScreenState extends ConsumerState<DetailChatScreen> {
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;
  late AsyncValue<UserModel> user;

  @override
  void initState() {
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    user = ref.read(userProvider);
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversation = ref.watch(conversationProvider(user.value!.id as int));
    final textIsEmpty = ref.watch(checkMessageProvider);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: CupertinoNavigationBar(
        middle: conversation.when(
          data: (data) {
            if (data.members!.isEmpty) {
              return const CupertinoListTile(
                padding: EdgeInsets.all(5),
                leadingSize: 45,
                leading: CircleAvatar(),
                title: Text('Belum ada percakapan'),
                subtitle: Text('Offline'),
              );
            }
            return CupertinoListTile(
              padding: const EdgeInsets.all(5),
              leadingSize: 45,
              leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(data.members![0].profileimageurl as String)),
              title: Text(data.members![0].fullname as String),
              subtitle: Text(
                  data.members!.first.isonline == true ? 'Online' : 'Offline'),
            );
          },
          error: (error, stackTrace) {
            return Text(error.toString());
          },
          loading: () {
            return const Text('User');
          },
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: CupertinoColors.systemGrey6,
              child: conversation.when(data: (data) {
                if (data.messages!.isEmpty) {
                  return const Center(child: Text('Tidak ada pesan'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: data.messages!.length,
                  itemBuilder: (context, index) {
                    final message = data.messages![index];
                    final previousMessage = index < data.messages!.length - 1
                        ? data.messages![index + 1]
                        : null;
                    // Check if the current message has a different date from the previous message
                    final showDateSection = previousMessage == null ||
                        !isSameDate(message.timecreated!.toDate(),
                            previousMessage.timecreated!.toDate());
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (showDateSection)
                          Align(
                              alignment: Alignment.center,
                              child: buildDateSection(
                                  message.timecreated!.toDate())),
                        BubbleChat(
                          date: message.timecreated!.toHoursString(),
                          isSender: message.useridfrom == user.value!.id,
                          message: message.text!,
                        ),
                      ],
                    );
                  },
                );
              }, error: (error, stackTrace) {
                return Text(error.toString());
              }, loading: () {
                return const CupertinoActivityIndicator();
              }),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: CupertinoTextField(
                      controller: _messageController,
                      placeholder: 'Ketik pesan...',
                      padding: const EdgeInsets.all(14),
                      maxLines: null,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          ref.watch(checkMessageProvider.notifier).state = true;
                        } else {
                          ref.watch(checkMessageProvider.notifier).state =
                              false;
                        }
                      },
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final sendLoading = ref.watch(sendLoadingProvider);

                      return CupertinoButton(
                        onPressed: textIsEmpty || sendLoading
                            ? null
                            : () async {
                                ref.watch(sendLoadingProvider.notifier).state =
                                    true;
                                final temp = _messageController.text;

                                await Future.delayed(const Duration(seconds: 1),
                                    () {
                                  ref.read(sendMessageProvider(temp));

                                  ref
                                      .watch(sendLoadingProvider.notifier)
                                      .state = false;
                                  ref.refresh(conversationProvider(
                                          user.value!.id as int)
                                      .future);
                                });
                                _messageController.clear();
                                ref.watch(checkMessageProvider.notifier).state =
                                    true;
                              },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: textIsEmpty
                                ? CupertinoColors.systemGrey
                                : CupertinoColors.activeBlue,
                            shape: BoxShape.circle,
                          ),
                          child: sendLoading
                              ? const CupertinoActivityIndicator()
                              : const Icon(
                                  CupertinoIcons.paperplane_fill,
                                  color: CupertinoColors.white,
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDateSection(DateTime timestamp) {
    final currentDate = DateTime.now();
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    String dateText;
    if (currentDate.difference(messageDate).inDays == 0) {
      dateText = 'Hari ini';
    } else if (currentDate.difference(messageDate).inDays == 1) {
      dateText = 'Kemarin';
    } else {
      dateText = DateFormat('d MMMM, yyyy').format(timestamp);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        dateText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    final same = date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
    print(same);
    return same;
  }
}
