import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_pptik/src/features/auth/provider/auth_notifier.dart';
import 'package:lms_pptik/src/features/user/provider/user_provider.dart';
import 'package:lms_pptik/src/routes/app_routes.dart';
import 'package:lms_pptik/src/views/components/loading_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              user.when(
                data: (data) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(data.avatar!),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name!,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: '${data.username!} | ',
                                    children: [TextSpan(text: data.email!)],
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Container();
                },
                loading: () => const Loading(),
              ),
              CupertinoListSection.insetGrouped(
                hasLeading: true,
                children: [
                  CupertinoListTile(
                    onTap: () {},
                    leading: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CupertinoColors.systemIndigo,
                      ),
                      child: const Icon(
                        CupertinoIcons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text('Edit Profil'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  CupertinoListTile(
                    onTap: () {},
                    leading: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CupertinoColors.systemYellow,
                      ),
                      child: const Icon(
                        Icons.folder_open,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text('Manajemen File'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  CupertinoListTile(
                    onTap: () {},
                    leading: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CupertinoColors.systemCyan,
                      ),
                      child: const Icon(
                        CupertinoIcons.checkmark_seal,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text('Lencana'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  CupertinoListTile(
                    onTap: () {},
                    leading: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CupertinoColors.systemGreen,
                      ),
                      child: const Icon(
                        CupertinoIcons.square_list,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text('Nilai'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  CupertinoListTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed('settings');
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CupertinoColors.black,
                      ),
                      child: const Icon(
                        CupertinoIcons.settings,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text('Pengaturan'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  CupertinoListTile(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          //About Dialog
                          return CupertinoAlertDialog(
                            title: const Text('Keluar'),
                            content: const Text('Apakah yakin ingin keluar?'),
                            actions: [
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                child: const Text('OK'),
                                onPressed: () {
                                  ref
                                      .watch(authNotifierProvider.notifier)
                                      .logout()
                                      .then((value) {
                                    Navigator.pop(context);
                                    GoRouter.of(context)
                                        .goNamed(AppRoutes.login);
                                  });
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text('Batal'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CupertinoColors.systemRed,
                      ),
                      child: const Icon(
                        CupertinoIcons.square_arrow_right,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: const Text('Keluar'),
                  ),
                ],
              ),
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          //About Dialog
                          return CupertinoAlertDialog(
                            title: const Text('Tentang'),
                            content:
                                const Text('Aplikasi ini dibuat oleh PPTIK'),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    leading: const Icon(
                      CupertinoIcons.question_circle,
                      color: Colors.black,
                    ),
                    title: const Text('Tentang'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
