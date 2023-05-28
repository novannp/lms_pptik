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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            user.when(
              data: (data) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: Column(
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                data.username!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                data.email!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Edit Profil'),
                        ),
                      )
                    ],
                  ),
                );
              },
              error: (error, stackTrace) {
                return Container();
              },
              loading: () => Loading(),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(
                Icons.folder_open,
                color: Colors.black,
              ),
              title: const Text('Manajemen File'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(
                Icons.folder_open,
                color: Colors.black,
              ),
              title: const Text('Manajemen File'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(
                Icons.folder_open,
                color: Colors.black,
              ),
              title: const Text('Manajemen File'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {
                ref.watch(authNotifierProvider.notifier).logout().then((value) {
                  GoRouter.of(context).goNamed(AppRoutes.login);
                });
              },
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: const Text('Keluar'),
            ),
          ],
        ),
      ),
    );
  }
}
