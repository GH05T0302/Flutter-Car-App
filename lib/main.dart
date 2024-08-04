import 'package:flutter/material.dart';
import 'package:ggt_assignment/Firebase_Auth/auth_provider.dart';
import 'package:ggt_assignment/Maintenance/maintenance_provider.dart';
import 'package:ggt_assignment/Maintenance/task_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ggt_assignment/Screens/vehicleList.dart';
import 'package:ggt_assignment/Screens/login.dart';
import 'package:ggt_assignment/Screens/dashboard.dart';
import 'package:ggt_assignment/vehicleProvider.dart';
import 'package:ggt_assignment/History/service_provider.dart';
import 'package:ggt_assignment/History/service_log_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 209, 44, 3),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          ],
          child: MaterialApp(
            theme: theme,
            initialRoute: '/',
            routes: {
              '/': (context) => LoginPage(),
              '/Dashboard': (context) => Dashboard(),
              '/VehicleList': (context) => VehicleListScreen(),
              '/TaskList': (context) => TaskListScreen(),
              '/ServiceLog': (context) => ServiceLogScreen(),
            },
          ),
        );
      },
    );
  }
}
