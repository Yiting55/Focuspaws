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
    return Scaffold(
      appBar: AppBar(title: Text("Achievement Book")),
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
          : Center(child: Text("No achievements yet.")),
    );
  }
  
}


