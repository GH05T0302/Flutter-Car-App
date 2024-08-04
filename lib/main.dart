import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:ggt_assignment/Firebase_Auth/auth_provider.dart';
import 'package:ggt_assignment/Maintenance/maintenance_provider.dart';
import 'package:ggt_assignment/Maintenance/task_list_screen.dart';
import 'package:ggt_assignment/Screens/vehicleList.dart';
import 'package:ggt_assignment/Screens/login.dart';
import 'package:ggt_assignment/Screens/dashboard.dart';
import 'package:ggt_assignment/vehicleProvider.dart';
import 'package:ggt_assignment/History/service_provider.dart';
import 'package:ggt_assignment/History/service_log_screen.dart';
import 'package:ggt_assignment/reminder/reminder_provider.dart';
import 'package:ggt_assignment/reminder/reminder_screen.dart';
import 'package:ggt_assignment/themeProvider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 209, 44, 3),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 209, 44, 3),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userEmail = authProvider.user?.email ?? '';
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => VehicleProvider(userEmail),
            ),
            ChangeNotifierProvider(
              create: (_) => ServiceProvider(userEmail),
            ),
            ChangeNotifierProvider(
              create: (context) => MaintenanceProvider(
                userEmail,
                Provider.of<ServiceProvider>(context, listen: false),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => ReminderProvider(userEmail),
            ),
          ],
          child: MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => LoginPage(),
              '/Dashboard': (context) => Dashboard(),
              '/VehicleList': (context) => VehicleListScreen(),
              '/TaskList': (context) => TaskListScreen(),
              '/ServiceLog': (context) => ServiceLogScreen(),
              '/Reminders': (context) => ReminderScreen(),
            },
          ),
        );
      },
    );
  }
}
