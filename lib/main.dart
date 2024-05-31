// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:focuspaws/features/app/splash_screen/splash_screen.dart';
//import 'package:focuspaws/features/login_page.dart';
import 'package:focuspaws/features/widget_tree.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FocusPaws",
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 245, 200, 41),
      ),
      home: const WidgetTree(),
      //SplashScreen(
        //child: LoginPage(),
      //),      
    );
  }
}