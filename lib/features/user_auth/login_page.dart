// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/petshop_page.dart';
import 'package:flutter_application_1/features/user_auth/forgotpassword_page.dart';
import 'package:flutter_application_1/features/user_auth/user_auth.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/features/pages/main_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  //bool showLoginPage = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signIn() async {
    
    if (emailController.text.trim().isEmpty) {
      _showErrorDialog('Please enter an email address.');
      return;
      }
    if (passwordController.text.trim().isEmpty) {
      _showErrorDialog('Please enter a password.');
      return;
    }
    showDialog(
      context: context, 
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      });

    try {
      await Auth().signInWithEmailandPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );
      UserCredential userCredential = await Auth().signInWithEmailandPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );
      User user = userCredential.user!;
      PetAndAchievements petAndAchievements = await loadPetAndAchievements(user);
      if (mounted) {
        Navigator.pop(context);
        if (petAndAchievements.pet != null) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) {
              return MainPage(
                petAndAchievements.pet!, 
                user, 
                petAndAchievements.achievements, 
                petAndAchievements.sleep, 
                petAndAchievements.foster,
                petAndAchievements.sleepTime, 
                petAndAchievements.cookTime, 
                petAndAchievements.fosterTime
              );
            }
          ),
        );
        } else {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) {
              return Petshop(user, petAndAchievements.achievements);
            }),
        );
      }
      }
      
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'invalid-credential':
          errorMessage = 'Please enter a valid email or password.';
          break;
        default:
          errorMessage = e.code;
          break;
      }
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override 
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
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
                _icon(),            
                _inputFieldEmail("Enter your Email", emailController),
                const SizedBox(height: 10),
                _inputFieldPassword("Enter your Password", passwordController, isPassword: true),
                const SizedBox(height: 5),
                _extraText(),
                const SizedBox(height: 10),
                _submitButton(),
                const SizedBox(height: 5),
                _loginOrRegisterButton(),
              ],
            ),
        ),
      ),);
  }

  Widget _header() {
    return Text(
      'Hello Again!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 36,
        fontFamily: 'OpenSans',
        color: Colors.white,
      ),
    );
  }

  Widget _icon() {
    return ClipOval(
      child: Image.asset(
        'assets/onboarding/logo.png',
        height: 300,
        width: 300,
        fit: BoxFit.cover,
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
                    
  Widget _inputFieldPassword(String hintText, TextEditingController controller, {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.white)
    );    
    return TextField(
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

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: signIn,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 130, 21),
            borderRadius: BorderRadius.circular(16),
          ), 
          child: Text(
            'Sign in',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      }, 
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
            onTap: widget.showRegisterPage,
            child: Text(
              'Register Now',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _extraText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ForgotPasswordPage();
                  }) 
                );
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 15, 
                color: Colors.blue,
                fontWeight: FontWeight.bold, 
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
