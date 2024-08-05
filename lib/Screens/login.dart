import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ggt_assignment/Firebase_Auth/firebase_auth_services.dart';
import 'package:ggt_assignment/Screens/SignUp.dart';
import 'package:ggt_assignment/widgets/container_widget.dart';
import 'package:ggt_assignment/toast.dart';
import 'package:ggt_assignment/widgets/customTextStyle.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  bool _rememberMe = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
      _rememberMe = true;
      _signIn(shouldShowLoading: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = getCustomTextStyle(context);
    final buttonTextStyle = TextStyle(color: Theme.of(context).colorScheme.onPrimary);
    final buttonBackgroundColor = Theme.of(context).colorScheme.primary;
    final linkTextStyle = TextStyle(color: Theme.of(context).colorScheme.primary);
    final titleTextStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: titleTextStyle,
              ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(
                height: 10,
              ),
              CheckboxListTile(
                title: Text("Remember Me", style: textStyle),
                value: _rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _signIn();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: buttonBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Login",
                            style: buttonTextStyle,
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: _showForgotPasswordDialog,
                child: Text(
                  "Forgot Password?",
                  style: linkTextStyle,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: textStyle),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: linkTextStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn({bool shouldShowLoading = true}) async {
    if (shouldShowLoading) {
      setState(() {
        _isSigning = true;
      });
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (shouldShowLoading) {
      setState(() {
        _isSigning = false;
      });
    }

    if (user != null) {
      if (_rememberMe) {
        _saveUserCredentials(email, password);
      }
      showToast(message: "User is successfully signed in");
      Navigator.pushNamed(context, "/Dashboard");
    } else {
      showToast(message: "Some error occurred");
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController emailController = TextEditingController();
        return AlertDialog(
          title: Text("Forgot Password"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: "Enter your email"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  await _auth.sendPasswordResetEmail(emailController.text);
                  Navigator.of(context).pop();
                } else {
                  showToast(message: "Please enter an email address.");
                }
              },
              child: Text("Send"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _saveUserCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }
}
