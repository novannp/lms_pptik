import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final notificationPluginProvider = Provider<NotificationPlugin>((ref) {
  return NotificationPlugin();
});

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    // final DarwinInitializationSettings darwinInitializationSettings =
    //     DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showWelcomeNotification(String name) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '17',
      'Welcome',
      category: AndroidNotificationCategory.event,
      importance: Importance.high,
      priority: Priority.high,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Hallo! $name',
      'Selamat datang di LMS PPTIK',
      const NotificationDetails(android: androidNotificationDetails),
    );
  }

  Future<void> pushNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '12345',
      'campaign',
      category: AndroidNotificationCategory.event,
      importance: Importance.high,
      priority: Priority.high,
    );
    await flutterLocalNotificationsPlugin.show(
      11,
      message.notification!.title,
      message.notification!.body,
      const NotificationDetails(android: androidNotificationDetails),
    );
  }
}
