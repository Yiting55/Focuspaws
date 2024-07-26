// ignore_for_file: unused_import, prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/pages/main_page.dart';
import 'package:flutter_application_1/features/pages/petshop_page.dart';
import 'package:flutter_application_1/features/pages/timer_page.dart';
import 'package:flutter_application_1/features/pages/calendar_page.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:flutter_application_1/features/user_auth/login_page.dart';
import 'package:flutter_application_1/features/user_auth/signinorregister_page.dart';
import 'package:flutter_application_1/features/user_auth/user_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:focuspaws/features/app/splash_screen/splash_screen.dart';
//import 'package:focuspaws/features/login_page.dart';
import 'package:flutter_application_1/features/onboarding/onboarding_page.dart';
import 'package:flutter_application_1/features/pet/achievement.dart';
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
                print('Error loading pet and achievements: ${snapshot.error}');
              }
          if (snapshot.hasData) {
            User user = snapshot.data!;
            return FutureBuilder<PetAndAchievements?>(
              future: loadPetAndAchievements(user),
              builder: (context, petSnapshot) {
                if (petSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (petSnapshot.hasData) {
                  PetAndAchievements data = petSnapshot.data!;
                  Pet? dog = data.pet;
                  if (dog == null) {
                    List<Achievement> achievements = [];
                    return Petshop(user, achievements);
                  }
                  List<Achievement> achievements = data.achievements;
                  bool sleep = data.sleep;
                  bool foster = data.foster;
                  DateTime sleepTime = data.sleepTime;
                  DateTime cookTime = data.cookTime;
                  DateTime fosterTime = data.fosterTime;
                  return MainPage(dog, user, achievements, sleep, foster,
                  sleepTime, cookTime, fosterTime);
                } else {
                  List<Achievement> achievements = [];
                  return Petshop(user, achievements);
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
 Future<PetAndAchievements> loadPetAndAchievements(User user) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    DocumentSnapshot userSnapshot = await firestore.collection('users').doc(user.email).get();
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
    if (userData == null) throw Exception('User data is null');

    // Handle pet data
    Pet? pet;
    if (userData['pet'] != null) {
      pet = Pet.fromMap(userData['pet'] as Map<String, dynamic>);
    }

    // Handle boolean values
    bool sleep = userData['sleep'] ?? false;
    bool foster = userData['foster'] ?? false;

    // Handle timestamp fields
    DateTime sleepTime = (userData['sleepTime'] as Timestamp?)?.toDate() ?? DateTime.now().subtract(const Duration(hours: 13));
    DateTime cookTime = (userData['cookTime'] as Timestamp?)?.toDate() ?? DateTime.now().subtract(const Duration(hours: 7));
    DateTime fosterTime = (userData['fosterTime'] as Timestamp?)?.toDate() ?? DateTime.now().subtract(const Duration(days:8));

    // Handle achievements
    List<Achievement> achievements = [];
    if (userData['achievements'] != null) {
      achievements = (userData['achievements'] as List)
          .map((a) => Achievement.fromMap(a as Map<String, dynamic>))
          .toList();
    }

    return PetAndAchievements(
      pet: pet,
      achievements: achievements,
      sleep: sleep,
      foster: foster,
      sleepTime: sleepTime,
      cookTime: cookTime,
      fosterTime: fosterTime,
    );
  } catch (e) {
    print('Failed to load pet and achievements: $e');
    return PetAndAchievements(
      pet: null,
      achievements: [],
      sleep: false,
      foster: false,
      sleepTime: DateTime.now().subtract(const Duration(hours: 13)),
      cookTime: DateTime.now().subtract(const Duration(hours: 7)),
      fosterTime: DateTime.now().subtract(const Duration(days: 8)),
    );
  }
}




class PetAndAchievements {
  final Pet? pet;
  final List<Achievement> achievements;
  bool sleep;
  bool foster;
  DateTime sleepTime;
  DateTime cookTime;
  DateTime fosterTime;


  PetAndAchievements({required this.pet, required this.achievements, 
  required this.sleep, required this.foster, 
  required this.sleepTime, required this.cookTime, required this.fosterTime});

   Map<String, dynamic> toMap() {
    return {
      'pet': pet?.toMap(),
      'achievements': achievements.map((a) => a.toMap()).toList(),
      'sleep': sleep,
      'foster': foster,
      'sleepTime': sleepTime.toIso8601String(),
      'cookTime': cookTime.toIso8601String(),
      'fosterTime': fosterTime.toIso8601String(),
    };
  }

  // Factory method to create an instance from a map
  factory PetAndAchievements.fromMap(Map<String, dynamic> map) {
    return PetAndAchievements(
      pet: map['pet'] != null ? Pet.fromMap(map['pet']) : null,
      achievements: (map['achievements'] as List).map((a) => Achievement.fromMap(a)).toList(),
      sleep: map['sleep'] ?? false,
      foster: map['foster'] ?? false,
      sleepTime: DateTime.parse(map['sleepTime']),
      cookTime: DateTime.parse(map['cookTime']),
      fosterTime: DateTime.parse(map['fosterTime']),
    );
  }
}
