// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
//import 'package:focuspaws/features/user_auth/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override 
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  
  final emailController = TextEditingController();

  @override 
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset link sent! Check your email.'),
          );
        }
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        });    
    }
  }


  @override 
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 252, 192, 40),
            Color.fromARGB(255, 255, 179, 57),
            Color.fromARGB(255, 251, 161, 44),
            Color.fromARGB(255, 254, 155, 25),
          ],
          stops: [0.1, 0.3, 0.7, 0.9],
        )),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 153, 28),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: _page(),
      ),  
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _resetText(),
            const SizedBox(height: 10),
            _inputFieldEmail('Email', emailController),
            const SizedBox(height: 10),
            _resetButton()
          ],
        ),
      ),
    );
  }

  Widget _resetText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Text(
        'Enter Your Email and we will send you a password reset link.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _inputFieldEmail(String hintText, TextEditingController controller, {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.white)
    );   
    return  TextField(
      style: const TextStyle(color: Colors.white),
      controller: emailController,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white, 
          fontFamily: 'OpenSans'),
      ),
      obscureText: isPassword,
    );
  } 

  Widget _resetButton() {
    return MaterialButton(
      onPressed: passwordReset,
      color: Colors.orange,
      child: Text('Reset Password'),
    );
  }
}