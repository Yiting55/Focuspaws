// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_import

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/bag_page.dart';
import 'package:flutter_application_1/features/pages/calendar_page.dart';
import 'package:flutter_application_1/features/pages/hunt_page.dart';
import 'package:flutter_application_1/features/pages/petshop_page.dart';
import 'package:flutter_application_1/features/pages/timer_page.dart';
import 'package:flutter_application_1/features/pet/achievement.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:flutter_application_1/features/pages/healthBar.dart';
import 'package:flutter_application_1/features/alert/alert.dart';
import 'package:flutter_application_1/features/user_auth/login_page.dart';
import 'package:flutter_application_1/features/user_auth/signinorregister_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/features/pages/achievementbook_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/main.dart';

class Intro extends StatelessWidget {
  final healthValue = 80;
  final growthValue = 0;
  User user;
  List<Achievement> achievements;

  Intro(this.user, this.achievements, {super.key});
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Background image
        Image.asset(
          'assets/onboarding/functions/6429.png',  // Replace with your own image path
          fit: BoxFit.cover,  // Adjust how the image fits the screen
          width: double.infinity,  // Match parent width
          height: double.infinity,  // Match parent height
        ),

        // start journey button
        Positioned(
          bottom: size.height * 0.18, // Adjust position from bottom
          right: size.width * 0.14, // Adjust position from right
          child: TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Continue'),
                content: Text(
                  'On pressed, you will start your journey. \nAre you ready?',
                  style: TextStyle(
                    fontSize: 16,
                  )),
                actions: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('I am ready!'),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Petshop(user, achievements)));
                        },
                      ),
                      TextButton(
                        child: Text('No, I want to explore more.'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, 
              backgroundColor: Color.fromARGB(255, 255, 130, 21),
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold),
            ),
            child: const Text('Start the Journey Here!')
          )
        ),

        // hunt button
        Positioned(
          bottom: size.height * 0.25, // Adjust position from bottom
          right: size.width * 0.14, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/hunt.png', // Replace with your own image path
              width: 300.0, // Adjust size as needed
              height: 75.0,
              fit: BoxFit.fill,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                title: Text('Hunt button'),
                content: Text("On pressed, you will be able to start focusing and get food rewards to feed your pet! \nStay focused for: \nat least 30 min to get 'Level 1' food, \nat least 60 minutes for 'Level 2' food, \nat least 90 minutes for 'Level 3' food. \nPlease note that the food will expire in 2 days from the day it is obtained."),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                ),
              );
            },
            iconSize: 300,
          ),
        ),

        // foster button
        Positioned(
          top: size.height * 0.22, // Adjust position from bottom
          right: size.width * 0.02, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/foster.png', // Replace with your own image path
              width: 50, // Adjust size as needed
              height: 50,
              fit: BoxFit.fill,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                title: Text('Foster button'),
                content: Text("On pressed, you will be able to foster your pet for a maximun of 10 days. \nWhen your pet is fostered, it's health value will be fixed at 80. \nIf already fostered, press it again to get it back. \nPlease note that time betwwen two fosters is at least 7 days."),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                ),
              );
            },
            iconSize: 300,
          ),
        ),

        // sleep button 
        Positioned(
          top: size.height * 0.3, // Adjust position from bottom
          right: size.width * 0.02, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/sleep.png', // Replace with your own image path
              width: 50, // Adjust size as needed
              height: 50,
              fit: BoxFit.fill,
            ),
            onPressed: () {
               showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                  title: Text('Sleep button'),
                  content: Text("On pressed, your pet will go to sleep for at most 8 hours. \nWhen this sleep mode is turned on, its health value will be fixed. \nIf the pet is already fostered, you will not be allowed to turn on 'sleep'. \nTo wake up your sleeping pet, just press this button again. \nPlease note that the time between each sleep is at least 12 hours."),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  ),
                );
            },
            iconSize: 300,
          ),
        ),

        // bag button
        Positioned(
          bottom: size.height * 0.05, // Adjust position from bottom
          left: size.width * 0.05, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/bag.png', // Replace with your own image path
              width: 50, // Adjust size as needed
              height: 50,
              fit: BoxFit.fill,
            ),
            onPressed: () {
               showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                title: Text('Bag button'),
                content: Text('On pressed, you will be able to view all the foods in your bag with expiry dates.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                ),
              );
              // Handle button 2 press
            },
            iconSize: 300,
          ),
        ),

        // achievement book button
        Positioned(
          bottom: size.height * 0.05, 
          left: size.width * 0.3, 
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/book.png', 
              width: 50, 
              height: 50,
              fit: BoxFit.fill,
            ),
            onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                  title: Text('Achievement book button'),
                  content: Text('On pressed, you will be able to view all the pets you have successfully raised up with their images at different stages.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  ),
                );
            },
            iconSize: 300,
          ),
        ),

        // feed button
        Positioned(
          bottom: size.height * 0.05, // Adjust position from bottom
          right: size.width * 0.3, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/cook.png', // Replace with your own image path
              width: 50, // Adjust size as needed
              height: 50,
              fit: BoxFit.fill,
            ),
            onPressed: () {
               showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                  title: Text('Feed button'),
                  content: Text("On pressed, you will be able to feed your pet. \nA 'Level 1' food will increase your pet's health value by 5, \n'Level 2' food will increase by 10, \nand 'Level 3' food will increase by 20 and add on 1 extra growth value. \nPlease note that the time between each feed is at least 6 hours."),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  ),
                );
            },
            iconSize: 300,
          ),
        ),

        // setting button
        Positioned(
          bottom: size.height * 0.05, // Adjust position from bottom
          right: size.width * 0.05, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/setting.png', // Replace with your own image path
              width: 50, // Adjust size as needed
              height: 50,
              fit: BoxFit.fill,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                title: Text('Setting button'),
                content: Text("On pressed,you will be able to proceed with 'logging out', 'resetting your password' and 'know more about knowledge' of raising a real pet dog."),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                ),
              );
            },
            iconSize: 300,
          ),
        ),

        // calendar button
        Positioned(
          top: size.height * 0.22, // Adjust position from bottom
          left: size.width * 0.02, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/calendar.png', // Replace with your own image path
              width: 50, // Adjust size as needed
              height: 50,
              fit: BoxFit.fill,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                title: Text('Calendar button'),
                content: Text('On pressed, you will be able to check your active dates since sign up date and the monthly report of your focus activities.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                ),
              );
            },
            iconSize: 300,
          ),
        ),

        // growth bar border 
        Positioned(
          top: size.height * 0.1,
          left: size.width * 0.18,
          child: 
          Container(
              width: 200.0, // Adjust the width of the progress bar container
              height: 20.0, // Adjust the height of the progress bar
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
        ),

        // growth bar fill
        Positioned(
          top: size.height * 0.1,
          left: size.width * 0.18,
          child: Container(
            width: 200.0 * growthValue / 150 , // Adjust the width of the progress bar
            height: 20.0, // Adjust the height of the progress bar
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(10.0),
              ),
          ),
        ),

        // growth bar text
        Positioned(
          top: size.height * 0.1,
          left: size.width * 0.02,
          child: const Text(
            "Growth",
            style: TextStyle(fontSize: 15, 
            color: Colors.black, 
            decoration: TextDecoration.none
            )
          )
        ),

        // health bar border
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.18,
          child: 
          Container(
              width: 200.0, // Adjust the width of the progress bar container
              height: 20, // Adjust the height of the progress bar
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
        ),

        // health bar fill
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.18,
          child: Container(
            width: 200.0 * healthValue / 100 , // Adjust the width of the progress bar
            height: 20.0, // Adjust the height of the progress bar
            decoration: BoxDecoration(
              color: Color.fromARGB(146, 255, 0, 0),
              borderRadius: BorderRadius.circular(10.0),
              ),
          ),
        ),

        // health bar text
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.02,
          child: const Text(
            "Health",
            style: TextStyle(fontSize: 15, 
            color: Colors.black, 
            decoration: TextDecoration.none
            )
          )
        ),

        // shop button
        Positioned(
          top: size.height * 0.3, // Adjust position from bottom
          left: size.width * 0.02, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/shop.png', // Replace with your own image path
              width: 50, // Adjust size as needed
              height: 50,
              fit: BoxFit.fill,
            ),
            onPressed: () {
             showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                title: Text('Customer awaiting button'),
                content: Text('This button only appears when your current pet is dead or its growth value reaches 150. \nOn pressed, you will be able to get your new pet from the shop.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                ),
              );
            },
            iconSize: 400,
          ),
        ),

        // health bar value
        Positioned(
          top: size.height * 0.155, // Adjust position from bottom
          right: size.width * 0.21,
          child: Text(
            '$healthValue/100',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),

        // growth bar value 
        Positioned(
          top: size.height * 0.105, // Adjust position from bottom
          right: size.width * 0.21,
          child: Text(
            '$growthValue/150',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),

        // pet image
        Center(
          child: Positioned(
            bottom: size.height * 0.25, // Adjust position from bottom
            right: size.width * 0.2, // Adjust position from right
            child: IconButton(
              icon: Image.asset(
                'assets/onboarding/functions/dog1.png', // Replace with your own image path
                width: 150, // Adjust size as needed
                height: 240,
                fit: BoxFit.fill,
              ),
              onPressed: () {
               showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                  title: Text("Your pet's appearance"),
                  content: Text("Your pet's appearance changes when its growth value reaches 50 or 100. \nHowever, if its health value reaches 0, your pet will die! \nAt each day's 0000AM, if its health value is greater than 80 (80 not inclusive), its growth value will increase by 1. \nWhen the pet is not sleeping or fostered, its health value drops by 2 per hour."),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  ),
                );
              },
              iconSize: 400,
            ),
          ),
        ),

        // sentence at the top
        Positioned(
          bottom: size.height * 0.68, // Adjust position from bottom
          right: size.width * 0.17, // Adjust position from right
          child: Text(
            'Press the buttons \nto see how they work!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),

        // sentence below
        Positioned(
          bottom: size.height * 0.55, // Adjust position from bottom
          right: size.width * 0.04, // Adjust position from right
          child: Text(
            "You can also press \non the pet's image!",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),


      ],
    );
  }
}