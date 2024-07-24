// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user_auth/login_page.dart';
import 'package:flutter_application_1/features/user_auth/register_page.dart';

class SigninOrRegisterPage extends StatefulWidget {
  const SigninOrRegisterPage({super.key});

  @override 
  State<SigninOrRegisterPage> createState() => _SigninOrRegisterPageState();
}

class _SigninOrRegisterPageState extends State<SigninOrRegisterPage> {
  bool showLoginPage = true;
  
  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleScreen);
    } else {
      return RegisterPage(showLoginPage: toggleScreen);
    }
  }
}