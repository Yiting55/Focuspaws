// ignore_for_file: prefer_const_constructors, avoid_print, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:focuspaws/features/pages/home_page.dart';
import 'package:focuspaws/features/pages/main_page.dart';
import 'package:focuspaws/features/user_auth/login_page.dart';
import 'package:focuspaws/features/user_auth/signinorregister_page.dart';
import 'package:focuspaws/features/user_auth/user_auth.dart';
import 'package:focuspaws/features/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:focuspaws/features/app/splash_screen/splash_screen.dart';
//import 'package:focuspaws/features/login_page.dart';
import 'package:focuspaws/features/onboarding/onboarding_view.dart';
import 'package:focuspaws/features/pet/pet.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboarding = prefs.getBool("onboarding") ?? false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});

  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FocusPaws",
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 245, 200, 41),
      ),
      home: StreamBuilder<User?>(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            //if (onboarding){
              //return OnboardingView();
            //} else {
            Pet dog = Pet();
            return MainPage(dog);
          }
          //} else {
          return const SigninOrRegisterPage();
          }
        
      ),
    );
  }
}     
