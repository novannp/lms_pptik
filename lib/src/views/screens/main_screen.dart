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
        currentIndex: ref.watch(indexProvider),
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey[400],
        elevation: 0,
        onTap: (value) {
          ref.watch(indexProvider.notifier).state = value;
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded), label: 'Kalender'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Lencana'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      body: IndexedStack(index: ref.watch(indexProvider), children: [
        DashboardScreen(),
        CalendarScreen(),
        NotificationScreen(),
        ProfileScreen(),
      ]),
    );
  }
}
