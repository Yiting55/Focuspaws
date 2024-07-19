// ignore_for_file: prefer_const_constructors, avoid_print, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/pages/home_page.dart';
import 'package:flutter_application_1/features/pages/main_page.dart';
import 'package:flutter_application_1/features/pages/petshop.dart';
import 'package:flutter_application_1/features/pages/timer_page.dart';
import 'package:flutter_application_1/features/pages/calendar_page.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:flutter_application_1/features/user_auth/login_page.dart';
import 'package:flutter_application_1/features/user_auth/signinorregister_page.dart';
import 'package:flutter_application_1/features/user_auth/user_auth.dart';
import 'package:flutter_application_1/features/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:focuspaws/features/app/splash_screen/splash_screen.dart';
//import 'package:focuspaws/features/login_page.dart';
import 'package:flutter_application_1/features/onboarding/onboarding_view.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboarding = prefs.getBool("onboarding") ?? false;

  await Firebase.initializeApp(
    name: "focuspaws",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});
  
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
          if (snapshot.hasData) {
            User user = snapshot.data!;
            return FutureBuilder<Pet?>(
              future: loadPetData(user),
              builder: (context, petSnapshot) {
                if (petSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (petSnapshot.hasData) {
                  Pet dog = petSnapshot.data!;
                  return MainPage(dog, user);
                } else {
                  return Petshop(user);
                }
              },
            );
          }
          return const SigninOrRegisterPage();
        }
      ),
    );
  }
}     

Future<void> savePetData(User user, Pet pet) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore.collection('pets').doc(user.uid).set({
    'type': pet.runtimeType.toString(),
    // Add any other necessary pet data here
  });
}

Future<Pet?> loadPetData(User user) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot snapshot = await firestore.collection('pets').doc(user.uid).get();

  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    String type = data['type'];

    if (type == 'Corgi') {
      return Corgi();
    }
    if (type == 'Samoyed') {
      return Samoyed();
    }
    if (type == 'GoldenRetriever') {
      return GoldenRetriever();
    }
    // Handle other pet types as necessary
  }
  return null;
}

void updatePet(User user, Pet newPet) {
  savePetData(user, newPet);
  // Call setState in the appropriate widget to update the UI
}