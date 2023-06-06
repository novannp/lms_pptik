import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/chat/provider/all_conversations.dart';
import '../../../features/chat/provider/conversation_by_id.dart';
import '../../../features/user/provider/user_provider.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    // final selfConversation = user.value?.id != null
    //     ? ref.watch(
    //         selfConversationProvider(ref.watch(userProvider).value!.id as int))
    //     : null;
    final allConversation = user.value?.id != null
        ? ref.watch(
            allConversationsProvider(ref.read(userProvider).value!.id as int))
        : null;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Obrolan'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () => ref.refresh(
                  allConversationsProvider(user.value!.id as int).future),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Material(
                    child: ExpansionTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      expandedAlignment: Alignment.centerLeft,
                      initiallyExpanded: true,
                      backgroundColor: CupertinoColors.white,
                      collapsedBackgroundColor: CupertinoColors.white,
                      title: Text(
                        'Pribadi',
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                      ),
                      children: allConversation!.when(
                          data: (data) {
                            return data.map((e) {
                              return CupertinoListTile(
                                onTap: () {
                                  if (kDebugMode) {
                                    print(e.members!.first.fullname);
                                  }
                                  ref
                                      .watch(conversationIdProvider.notifier)
                                      .state = e.id!;
                                  GoRouter.of(context).pushNamed('detail_chat');
                                },
                                title: Text(
                                  '${e.members!.first.fullname}',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                ),
                                leading: Badge(
                                  backgroundColor: CupertinoColors.activeGreen,
                                  offset: const Offset(0, 25),
                                  label: const Text('  '),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(
                                      e.members!.first.profileimageurl
                                          .toString(),
                                    ),
                                  ),
                                ),
                                leadingSize: 40,
                                subtitle: Html(
                                    data: e.messages!.isEmpty ||
                                            e.messages == null
                                        ? ''
                                        : e.messages!.first.text),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: CupertinoColors.white,
                                trailing: const Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: CupertinoColors.black,
                                ),
                              );
                            }).toList();
                          },
                          error: (error, stackTrace) {
                            return [Text(error.toString())];
                          },
                          loading: () => [
                                const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ]),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
