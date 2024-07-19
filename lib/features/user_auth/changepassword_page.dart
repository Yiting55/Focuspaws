// ignore_for_file: unused_local_variable, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/user_auth/signinorregister_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  
  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  bool _passwordsMatch() {
    if (_newPasswordController.text.trim() == _confirmNewPasswordController.text.trim()) {
      return true;
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Passwords do not match!'),
          );
        },
      );
      return false;
    }
  }

  Future<void> _changePassword() async {
    if (_passwordsMatch()) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String email = user.email!;

          // Reauthenticate the user
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _oldPasswordController.text,
          );
          await user.reauthenticateWithCredential(credential);

          // Update the password
          await user.updatePassword(_newPasswordController.text);

          // Sign the user out and in again to ensure they have to use the new password
          Navigator.pop(context);
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(20.0),
                content: Text(
                  'Password updated successfully. Please log in again.',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 18,
                  )
                  ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SigninOrRegisterPage()));
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        String errorMessage = 'An error occurred';
        if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          errorMessage = 'The user password is wrong';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'requires-recent-login') {
          errorMessage = 'Please re-login and try again.';
        }
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(errorMessage),
            );
          },
        );
      }
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
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            '',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontFamily: 'Open Sans'
            ),
          ),
          backgroundColor: Colors.transparent,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _header(),
              const SizedBox(height: 30),
              _inputField("Enter Old Password", _oldPasswordController, isPassword: true),
              const SizedBox(height: 15),
              _inputField("Enter New Password", _newPasswordController, isPassword: true),
              const SizedBox(height: 15),
              _inputField("Confirm New Password", _confirmNewPasswordController, isPassword: true),
              const SizedBox(height: 30),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Text(
      'Change Password',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 36,
        fontFamily: 'OpenSans',
        color: Colors.black,
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.white),
    );
    return TextField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: Icon(
          isPassword ? Icons.lock : Icons.email,
          color: Colors.black,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'OpenSans',
        ),
      ),
      obscureText: isPassword,
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: _changePassword,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 116, 24),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Submit',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }
}

    
