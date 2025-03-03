import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // True ise login ekranı, false ise register ekranı gösterilir
  bool showLoginScreen = true;

  void toggleScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(showRegisterScreen: toggleScreen);
    } else {
      return RegisterScreen(showLoginScreen: toggleScreen);
    }
  }
}