import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ggt_assignment/Maintenance/maintenance_task.dart';
import 'package:ggt_assignment/main.dart'; // Ensure you import main.dart to access flutterLocalNotificationsPlugin
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderProvider with ChangeNotifier {
  final String userEmail;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  ReminderProvider(this.userEmail) {
    fetchReminders();
    _initFirebaseMessaging();
    tz.initializeTimeZones();
  }

  List<MaintenanceTask> _reminders = [];
  List<MaintenanceTask> get reminders => _reminders;

  Future<void> _initFirebaseMessaging() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        print('Received a message in the foreground');
        // Handle the notification in the foreground if needed
      }
    });
  }

  Future<void> fetchReminders() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('maintenance')
          .doc(userEmail)
          .collection('userTasks')
          .where('dueDate', isGreaterThanOrEqualTo: DateTime.now())
          .orderBy('dueDate')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No reminders found for this user.');
      }

      _reminders = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return MaintenanceTask.fromMap(data);
      }).toList();

      // Schedule notifications for reminders due in a week
      for (var reminder in _reminders) {
        final dueDate = reminder.dueDate;
        final scheduledDate = dueDate.subtract(Duration(days: 7));

        if (scheduledDate.isAfter(DateTime.now())) {
          _scheduleNotification(reminder, scheduledDate);
        }
      }

      notifyListeners();
    } catch (error) {
      print('Error fetching reminders: $error');
    }
  }

  Future<void> _scheduleNotification(MaintenanceTask task, DateTime scheduledDate) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.hashCode,
      'Maintenance Reminder',
      'Your task "${task.task}" is due in a week.',
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> snoozeReminder(MaintenanceTask task, Duration snoozeDuration) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('maintenance')
          .doc(userEmail)
          .collection('userTasks')
          .where('taskID', isEqualTo: task.taskID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;

        final newDueDate = task.dueDate.add(snoozeDuration);
        await FirebaseFirestore.instance
            .collection('maintenance')
            .doc(userEmail)
            .collection('userTasks')
            .doc(docId)
            .update({'dueDate': newDueDate.toIso8601String()});

        await fetchReminders(); // Refresh reminders after snooze

        print('Reminder snoozed successfully');
      } else {
        print('No matching document found to snooze');
      }
    } catch (error) {
      print('Error snoozing reminder: $error');
    }
  }

  Future<void> completeReminder(MaintenanceTask task) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('maintenance')
          .doc(userEmail)
          .collection('userTasks')
          .where('taskID', isEqualTo: task.taskID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;

        // Mark as completed and add to service log
        await FirebaseFirestore.instance
            .collection('maintenance')
            .doc(userEmail)
            .collection('userTasks')
            .doc(docId)
            .delete();

        await fetchReminders(); // Refresh reminders after completing

        print('Reminder completed and moved to service log');
      } else {
        print('No matching document found to complete');
      }
    } catch (error) {
      print('Error completing reminder: $error');
    }
  }
}
