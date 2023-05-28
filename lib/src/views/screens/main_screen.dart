import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/views/screens/notification_screen.dart';
import 'package:lms_pptik/src/views/screens/profile_screen.dart';
import 'package:lms_pptik/src/views/themes.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.watch(indexProvider),
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.black,
        elevation: 0,
        onTap: (value) {
          ref.watch(indexProvider.notifier).state = value;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.glance_12_regular),
            label: 'Dashboard',
            activeIcon: Icon(FluentIcons.glance_12_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.calendar_rtl_12_regular),
            label: 'Kalender',
            activeIcon: Icon(FluentIcons.calendar_rtl_12_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.shield_12_regular),
            label: 'Lencana',
            activeIcon: Icon(FluentIcons.shield_12_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.person_12_regular),
            label: 'Profil',
            activeIcon: Icon(FluentIcons.person_12_filled),
          ),
        ],
      ),
      body: IndexedStack(
        index: ref.watch(indexProvider),
        children: const [
          DashboardScreen(),
          CalendarScreen(),
          NotificationScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
