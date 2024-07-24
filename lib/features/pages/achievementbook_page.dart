// ignore_for_file: prefer_const_constructors, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:flutter_application_1/features/pet/achievement.dart';

class AchievementBookPage extends StatelessWidget {
  final User user;
  final List<Achievement> achievements;
  const AchievementBookPage({super.key, required this.user, required this.achievements});
  
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
        appBar: AppBar(title: Text("Achievement Book"), backgroundColor: Colors.transparent,),
        backgroundColor: Colors.transparent,
        body: achievements.isNotEmpty
            ? ListView.builder(
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  Achievement achievement = achievements[index];
                  return ListTile(
                    leading: Image.asset(achievement.loadPicture(achievement.petName)),
                    title: Text(achievement.petName)
      
                  );
                },
              )
            : Center(child: Text("No achievements yet.", style: TextStyle(fontSize: 24))),
      ),
    );
  }
  
}

