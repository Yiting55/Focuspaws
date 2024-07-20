// ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/features/pet/pet.dart';

// class AchievementBookPage extends StatelessWidget {
//   final User user;
//   const AchievementBookPage({super.key, required this.user});
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Achievement Book")),
//       body: FutureBuilder<List<Pet>>(
//         future: loadAchievementBook(user),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//           if (snapshot.hasData) {
//             List<Pet> pets = snapshot.data!;
//             return ListView.builder(
//               itemCount: pets.length,
//               itemBuilder: (context, index) {
//                 Pet pet = pets[index];
//                 String name = pet.name;
//                 return ListTile(
//                   title: Text(name),
//                 );
//               },
//             );
//           } else {
//             return Text("No achievements yet.");
//           }
//         },
//       ),
//     );
//   }

//   Future<List<Pet>> loadAchievementBook(User user) async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     QuerySnapshot querySnapshot = await firestore.collection('users').doc(user.uid).collection('achievement_book').get();

//     return querySnapshot.docs.map((doc) {
//       return Pet.fromMap(doc.data() as Map<String, dynamic>);
//     }).toList();
//   }
// }

