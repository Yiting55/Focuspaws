// ignore_for_file: prefer_const_constructors, unused_element, file_names

import 'package:flutter/material.dart';
import 'package:focuspaws/features/user_auth/pages/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailandPassword(
        email: usernameController.text, 
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailandPassword(
        email: usernameController.text, 
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
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
            _icon(),
            const SizedBox(height: 50),
            _inputFieldEmail("Enter your Username", usernameController),
            const SizedBox(height: 20),
            _inputFieldPassword("Enter your Password", passwordController, isPassword: true),
            const SizedBox(height: 50),
            _submitButton(),
            const SizedBox(height: 20),
            _loginOrRegisterButton(),
            const SizedBox(height: 20),
            _extraText()
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle),
      child: Icon(Icons.person),
      //Image.asset('assets/images/dogicon.png'),
      );
  }

  Widget _inputFieldEmail(String hintText, TextEditingController controller, {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white)
    );   
    return  TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      obscureText: isPassword,
    );
  }
                    
  Widget _inputFieldPassword(String hintText, TextEditingController controller, {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white)
    );    
    return  TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: Icon(
          Icons.key,
          color: Colors.white,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      obscureText: isPassword,
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      //() {
        //debugPrint("Username : ${usernameController.text}");
        //debugPrint("Password : ${usernameController.text}");
      //},
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(), 
        backgroundColor: Color.fromARGB(255, 255, 196, 34),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ), 
      child: Text(isLogin ? 'Sign in' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      }, 
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  Widget _extraText() {
    return const Text(
      "Can't access to your account?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }

}