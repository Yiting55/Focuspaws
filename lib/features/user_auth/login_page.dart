// ignore_for_file: prefer_const_constructors, unused_element, file_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/main_page.dart';
import 'package:flutter_application_1/features/pages/petshop_page.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:flutter_application_1/features/user_auth/forgotpassword_page.dart';
//import 'package:focuspaws/features/user_auth/register_page.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/features/user_auth/user_auth.dart';

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

        Navigator.pop(context);
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) {
              Pet dog = Pet();
              return MainPage(dog);
            }),
        );
      
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Text(e.code),
          );
        });
    }
  }

  //void toggleScreen() {
    //setState(() {
      //showLoginPage = !showLoginPage;
    //});
  //}

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
                //const SizedBox(height: 0),
                _icon(),
                //const SizedBox(height: 0),
                _inputFieldEmail("Enter your Username", emailController),
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
      //onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
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
      //Text(isLogin ? 'Sign in' : 'Register'),
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
            onTap: widget.showRegisterPage,//(){
              //Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterPage()));
            //},
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