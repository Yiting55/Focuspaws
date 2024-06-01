import 'package:firebase_auth/firebase_auth.dart';
import 'package:focuspaws/features/user_auth/signinorregister_page.dart';
import 'package:focuspaws/features/user_auth/user_auth.dart';
import 'package:focuspaws/features/pages/home_page.dart';
//import 'package:focuspaws/features/Login_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return const HomePage();
        } else {
          return const SigninOrRegisterPage();
        }
      },
    );
  }
}