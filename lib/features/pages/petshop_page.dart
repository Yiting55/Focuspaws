// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, prefer_const_constructors, prefer_initializing_formals, use_key_in_widget_constructors, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/main_page.dart';
import 'package:flutter_application_1/features/pet/achievement.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Petshop extends StatelessWidget {
  User user;
  List<Achievement> achievements;

  Petshop(User user, List<Achievement> achievements)
  : user = user,
    achievements = achievements;

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Pet House',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
              fontFamily: 'Open Sans',
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [

            // corgi
            Positioned(
              top: size.height * 0.2, // Adjust position from bottom
              right: size.width * 0.36, // Adjust position from right
              child: IconButton(
                icon: Image.asset(
                  'assets/onboarding/Corgi1.png', // Replace with your own image path
                  width: 100.0, // Adjust size as needed
                  height: 160.0,
                  fit: BoxFit.fill,
                ),
                onPressed: () {
                  DateTime _lastCookTime = DateTime.now().subtract(const Duration(hours: 7));
                      DateTime _lastSleepTime = DateTime.now().subtract(const Duration(hours: 12));
                      DateTime _lastFosterTime = DateTime.now().subtract(const Duration(days: 8));
                  savePetAndAchievements(user, Pet('Corgi', 80, 0), achievements, false, false, 
                    _lastSleepTime, _lastCookTime, _lastFosterTime);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => 
                    MainPage(Pet('Corgi', 80, 0), user, achievements, false, false, 
                    _lastSleepTime, _lastCookTime, _lastFosterTime)));
                },
                iconSize: 400,
              ),
            ), 
            // corgi label
            Positioned(
              top: size.height * 0.36,
              right: size.width * 0.43,
              child: Text(
                'Corgi',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ), 

            // samoyed
            Positioned(
              top: size.height * 0.42, // Adjust position from bottom
              right: size.width * 0.35,// Adjust position from right
              child: IconButton(
                icon: Image.asset(
                  'assets/onboarding/samo1.png', // Replace with your own image path
                  width: 140.0, // Adjust size as needed
                  height: 200.0,
                  fit: BoxFit.fill,
                ),
                onPressed: () {
                  DateTime _lastCookTime = DateTime.now().subtract(const Duration(hours: 7));
                      DateTime _lastSleepTime = DateTime.now().subtract(const Duration(hours: 12));
                      DateTime _lastFosterTime = DateTime.now().subtract(const Duration(days: 8));
                  savePetAndAchievements(user, Pet('Samoyed', 80, 0), achievements, false, false, 
                    _lastSleepTime, _lastCookTime, _lastFosterTime);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => 
                    MainPage(Pet('Samoyed', 80, 0), user, achievements, false, false, 
                    _lastSleepTime, _lastCookTime, _lastFosterTime)));
                },
                iconSize: 400,
              ),
            ),  
            // samoyed label
            Positioned(
              top: size.height * 0.6,
              right: size.width * 0.4,
              child: Text(
                'Samoyed',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ),

            // golden
            Positioned(
              top: size.height * 0.68, // Adjust position from bottom
              right: size.width * 0.32, // Adjust position from right
              child: IconButton(
                icon: Image.asset(
                  'assets/onboarding/golden1.png', // Replace with your own image path
                  width: 140.0, // Adjust size as needed
                  height: 240.0,
                  fit: BoxFit.fill,
                ),
                onPressed: () {
                  DateTime _lastCookTime = DateTime.now().subtract(const Duration(hours: 7));
                      DateTime _lastSleepTime = DateTime.now().subtract(const Duration(hours: 12));
                      DateTime _lastFosterTime = DateTime.now().subtract(const Duration(days: 8));
                    savePetAndAchievements(user, Pet('Golden Retriever', 80, 0), achievements, false, false, 
                    _lastSleepTime, _lastCookTime, _lastFosterTime);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => 
                    MainPage(Pet('Golden Retriever', 80, 0), user, achievements, false, false, 
                    _lastSleepTime, _lastCookTime, _lastFosterTime)));
                },
                iconSize: 400,
              ),
            ), 
            // golden label
            Positioned(
              top: size.height * 0.84,
              right: size.width * 0.32,
              child: Text(
                'Golden Retriever',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ),     
        
          ]
        ),
      ),
    );
  }
}

Future<void> savePetAndAchievements(
  User user,
  Pet pet,
  List<Achievement> achievements,
  bool sleep,
  bool foster,
  DateTime sleepTime,
  DateTime cookTime,
  DateTime fosterTime
) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    print('Saving data for user ID: ${user.email}');
    
    await firestore.collection('users').doc(user.email).set({
      'pet': pet.toMap(), // Ensure Pet class has a toMap method to convert it to a Map
      'achievements': achievements.map((a) => a.toMap()).toList(), // Ensure Achievement class has a toMap method
      'sleep': sleep,
      'foster': foster,
      'sleepTime': Timestamp.fromDate(sleepTime), // Convert DateTime to Timestamp
      'cookTime': Timestamp.fromDate(cookTime),   // Convert DateTime to Timestamp
      'fosterTime': Timestamp.fromDate(fosterTime) // Convert DateTime to Timestamp
    }, SetOptions(merge: true)); // Use SetOptions to merge with existing data
    print('Pet and achievements saved successfully');
  } catch (e) {
    print('Failed to save pet and achievements: $e');
  }
}
