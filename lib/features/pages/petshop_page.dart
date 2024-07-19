// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/main_page.dart';
import 'package:flutter_application_1/features/pet/pet.dart';

class Petshop extends StatelessWidget {
  User user;

  Petshop(this.user, {super.key});

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
          top: size.height * 0.19, // Adjust position from bottom
          right: size.width * 0.1, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/Corgi1.png', // Replace with your own image path
              width: 80.0, // Adjust size as needed
              height: 100.0,
              fit: BoxFit.fill,
            ),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => MainPage(Corgi(), user)));
            },
            iconSize: 400,
          ),
        ),  

        Positioned(
          top: size.height * 0.2, // Adjust position from bottom
          right: size.width * 0.43,// Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/samo1.png', // Replace with your own image path
              width: 80.0, // Adjust size as needed
              height: 100.0,
              fit: BoxFit.fill,
            ),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => MainPage(Samoyed(), user)));
            },
            iconSize: 400,
          ),
        ),  

        Positioned(
          top: size.height * 0.19, // Adjust position from bottom
          right: size.width * 0.7, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/golden1.png', // Replace with your own image path
              width: 100.0, // Adjust size as needed
              height: 150.0,
              fit: BoxFit.fill,
            ),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => MainPage(GoldenRetriever(), user)));
            },
            iconSize: 400,
          ),
        ),      

      ]
    );
  }
}