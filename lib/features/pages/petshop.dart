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
    return Stack(
      children: [
        Image.asset(
          'assets/onboarding/shopBack.png',  // Replace with your own image path
          fit: BoxFit.cover,  // Adjust how the image fits the screen
          width: double.infinity,  // Match parent width
          height: double.infinity,  // Match parent height
        ),

        Positioned(
          top: size.height * 0.1, // Adjust position from bottom
          right: size.width * 0.25,
          child: Text(
            'Customer awaiting',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),

        Positioned(
          top: size.height * 0.2, // Adjust position from bottom
          right: size.width * 0.35, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/Corgi1.png', // Replace with your own image path
              width: 120.0, // Adjust size as needed
              height: 120.0,
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

        Positioned(
          top: size.height * 0.45, // Adjust position from bottom
          right: size.width * 0.35,// Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/samo1.png', // Replace with your own image path
              width: 140.0, // Adjust size as needed
              height: 120.0,
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

        Positioned(
          top: size.height * 0.7, // Adjust position from bottom
          right: size.width * 0.35, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/golden1.png', // Replace with your own image path
              width: 140.0, // Adjust size as needed
              height: 120.0,
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

      ]
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
    print('Saving data for user ID: ${user.uid}');
    
    await firestore.collection('users').doc(user.uid).set({
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