import 'package:flutter/material.dart';
import 'package:ggt_assignment/Firebase_Auth/firebase_auth_services.dart';
import 'package:ggt_assignment/Screens/changePasswordScreen.dart';
import 'package:ggt_assignment/Screens/login.dart';
import 'package:ggt_assignment/providers/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  final provider = Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                },
              ),
            ),
            ListTile(
              title: Text('Change Password'),
              trailing: Icon(Icons.lock),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.logout),
              onTap: () async {
                await _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Clear saved credentials
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');

    // Sign out from Firebase
    await _authService.signOut();

    // Navigate to login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
