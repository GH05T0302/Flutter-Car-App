import 'package:flutter/material.dart';
import 'package:ggt_assignment/Screens/vehicleList.dart';
import 'package:provider/provider.dart';
import 'package:ggt_assignment/Screens/login.dart';
import 'package:ggt_assignment/Screens/VehicleManagementScreen.dart';
import 'package:ggt_assignment/Screens/SignUp.dart';  // Import the SignUp page
import 'package:ggt_assignment/vehicleProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Color.fromARGB(255, 209, 44, 3),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/vehicleList': (context) => VehicleListScreen(), // Define the route for VehicleList
      },
    );
  }
}
