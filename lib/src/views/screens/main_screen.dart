import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/views/screens/badge_screen.dart';
import 'package:lms_pptik/src/views/screens/chat/chat_screen.dart';
import 'package:lms_pptik/src/views/screens/profile_screen.dart';

import 'calendar_screen.dart';
import 'dashboard_screen.dart';

final indexProvider = StateProvider<int>((ref) {
  return 0;
});

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  late CupertinoTabController _tabController;

  @override
  void initState() {
    _tabController = CupertinoTabController();
    FirebaseMessaging.onMessage.listen((event) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        iconSize: 24,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Dashboard',
            // activeIcon: Icon(FluentIcons.glance_12_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: 'Obrolan',
            // activeIcon: Icon(FluentIcons.calendar_rtl_12_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'Kalender',
            // activeIcon: Icon(FluentIcons.calendar_rtl_12_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.checkmark_seal),
            label: 'Lencana',
            // activeIcon: Icon(FluentIcons.shield_12_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profil',
            // activeIcon: Icon(FluentIcons.person_12_filled),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return DashboardScreen(_tabController);
          case 1:
            return const ChatScreen();
          case 2:
            return const CalendarScreen();
          case 3:
            return const BadgeScreen();
          case 4:
            return const ProfileScreen();
          default:
            return DashboardScreen(_tabController);
        }
      },
    );
  }
}
