//import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:focuspaws/features/pages/home_page.dart';
import 'package:focuspaws/features/user_auth/user_auth.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override 
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;

  @override 
  void initState() {
    super.initState();
    isEmailVerified = Auth().currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = Auth().currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      //Utils.showSnackBar(e.toString());
    }
  }

  @override 
  Widget build(BuildContext context) => isEmailVerified 
      ? HomePage()
      : const Scaffold(
      );
}