// ignore_for_file: prefer_const_constructors

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focuspaws/features/user_auth/user_auth.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override 
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage = '';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  
  @override 
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (passwordConfirmed()) {
      try {
        await Auth().createUserWithEmailandPassword(
          email: emailController.text, 
          password: passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }
  }

  bool passwordConfirmed() {
    if (passwordController.text.trim() == confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
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
        child: SingleChildScrollView(
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _header(),
                const SizedBox(height: 20),
                _icon(),
                const SizedBox(height: 20),
                _inputFieldEmail("Enter your Username", emailController),
                const SizedBox(height: 10),
                _inputFieldPassword("Enter your Password", passwordController, isPassword: true),
                const SizedBox(height: 10),
                _inputFieldConfirmedPassword("Confirm your Password", confirmpasswordController, isPassword: true),
                const SizedBox(height: 10),
                _submitButton(),
                const SizedBox(height: 10),
                _loginOrRegisterButton(),
              ],
            ),
        ),
      ),);
  }

  Widget _header() {
    return Text(
      'Hello There!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 36,
        fontFamily: 'OpenSans'
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 4),
        shape: BoxShape.circle),
      child: Icon(Icons.person, size: 50),
      //Image.asset('assets/images/dogicon.png'),
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
                    
  Widget _inputFieldPassword(String hintText, TextEditingController controller, {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.white)
    );    
    return  TextField(
      style: const TextStyle(color: Colors.white),
      controller: passwordController,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: Icon(
          Icons.key,
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

  Widget _inputFieldConfirmedPassword(String hintText, TextEditingController controller, {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.white)
    );    
    return  TextField(
      style: const TextStyle(color: Colors.white),
      controller: confirmpasswordController,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: Icon(
          Icons.key,
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

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: signUp,
      //onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(16),
          ), 
          child: Text(
            'Sign up',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
      //Text(isLogin ? 'Sign in' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {}, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Not a member? ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'), 
          ),
          GestureDetector(
            onTap: widget.showLoginPage,
            child: Text(
              'Login Now',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans'),
            ),
          ),
        ],
      ),
      //Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }
}