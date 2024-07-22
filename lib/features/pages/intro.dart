
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/bag_page.dart';
import 'package:flutter_application_1/features/pages/calendar_page.dart';
import 'package:flutter_application_1/features/pages/hunt_page.dart';
import 'package:flutter_application_1/features/pages/petshop.dart';
import 'package:flutter_application_1/features/pages/timer_page.dart';
import 'package:flutter_application_1/features/pet/achievement.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:flutter_application_1/features/pages/healthBar.dart';
import 'package:flutter_application_1/features/alert/alert.dart';
import 'package:flutter_application_1/features/user_auth/login_page.dart';
import 'package:flutter_application_1/features/user_auth/signinorregister_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/features/pages/petshop.dart';
import 'package:flutter_application_1/features/pages/achievementbook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/features/pet/achievement.dart';

class Intro extends StatelessWidget {
  final healthValue = 80;
  final growthValue = 0;
  User user;
  List<Achievement> achievements;

  Intro(User user, List<Achievement> achievements) 
    : this.user = user,
      this.achievements = achievements;
  
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

        Positioned(
          top: size.height * 0.18, // Adjust position from bottom
          right: size.width * 0.03, // Adjust position from right
          child: IconButton(
      onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text('Continue button'),
                                  content: Text('On pressed, you will start your journey. Are you ready?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('I am ready!'),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Petshop(user, achievements)));
                                      },
                                    ),
                                    TextButton(
                                      child: Text('No, I want to explore more about the functions.'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                  ),
                                ),
      color: Colors.black, 
      icon: const Icon(Icons.logout),
      iconSize: 30,
    )
        ),

        // First button positioned relative to the background
        Positioned(
          bottom: size.height * 0.15, // Adjust position from bottom
          right: size.width * 0.1, // Adjust position from right
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
                                  content: Text('On pressed, you will be able to start focusing and get rewards to feed your customer! \nStay focused for 30 min to get a level 1 food, \n1 hour for a level 2 food, \n2 hours for level 3 food. \nPlease note that the food you get will be expired in 3 days. '),
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

        Positioned(
          top: size.height * 0.23, // Adjust position from bottom
          right: size.width * 0.01, // Adjust position from right
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
                                  content: Text('On pressed, you will be able to foster your customer for maximun of 10 days. \nDuring it\'s health value will be fixed at 80. \nIf already fostered, press it again to get it back. \nPlease note that time betwwen two fosters should be at least 7 days.'),
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

        Positioned(
          top: size.height * 0.3, // Adjust position from bottom
          right: size.width * 0.001, // Adjust position from right
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
                                  content: Text('On pressed, your customer will go sleep for at most 8 hours during when its health value will be fixed. \nIf it is already fostered, you will not allowed to ask it to go sleep. \nIf sleeping already, press again to wake it up. \nPlease note that the time between each sleep should be at least 12 hours.'),
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
                                  content: Text('On pressed, you will be able to view the food in your bag with expiring dates.'),
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

        Positioned(
          bottom: size.height * 0.05, // Adjust position from bottom
          left: size.width * 0.3, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/book.png', // Replace with your own image path
              width: 50, // Adjust size as needed
              height: 50,
              fit: BoxFit.fill,
            ),
            onPressed: () {
                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text('Achievement book button'),
                                  content: Text('On pressed, you will be able to view the past customers that you have successfully raised up with images at their different stages.'),
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
                                  content: Text('On pressed, you will be able to feed your customer. \nA level 1 food will give your customer 5 health value, \nlevel 2 food will give 10 health point, \nand level 3 food will give 20 health value and 1 extra growth value. \nPlease note that the time between each feed should be at least 6 hours.'),
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
                                  content: Text('On pressed,you will be able to proceed with logging out, resetting your password and know more about knowledge of raising a real pet.'),
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

        Positioned(
          top: size.height * 0.2, // Adjust position from bottom
          left: size.width * 0.01, // Adjust position from right
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
                                  content: Text('On pressed, you will be able to check your active dates and check your daily and monthly report.'),
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

        Positioned(
          top: size.height * 0.1,
          left: size.width * 0.17,
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

        Positioned(
          top: size.height * 0.1,
          left: size.width * 0.17,
          child: Container(
            width: 200.0 * growthValue / 150 , // Adjust the width of the progress bar
            height: 20.0, // Adjust the height of the progress bar
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(10.0),
              ),
          ),
        ),

        Positioned(
          top: size.height * 0.1,
          left: size.width * 0.01,
          child: const Text(
            "Growth",
            style: TextStyle(fontSize: 15, 
            color: Colors.black, 
            decoration: TextDecoration.none
            )
          )
        ),

        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.17,
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

        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.17,
          child: Container(
            width: 200.0 * healthValue / 100 , // Adjust the width of the progress bar
            height: 20.0, // Adjust the height of the progress bar
            decoration: BoxDecoration(
              color: Color.fromARGB(146, 255, 0, 0),
              borderRadius: BorderRadius.circular(10.0),
              ),
          ),
        ),

        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.01,
          child: const Text(
            "Health",
            style: TextStyle(fontSize: 15, 
            color: Colors.black, 
            decoration: TextDecoration.none
            )
          )
        ),

      
        Positioned(
          top: size.height * 0.27, // Adjust position from bottom
          left: size.width * 0.01, // Adjust position from right
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
                                  content: Text('This button will be appear only when your current customer is dead or its growth value reaches 150. On pressed, you will be able to get your next customer.'),
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

        Positioned(
          top: size.height * 0.155, // Adjust position from bottom
          right: size.width * 0.18,
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

        Positioned(
          top: size.height * 0.105, // Adjust position from bottom
          right: size.width * 0.18,
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

        Positioned(
          bottom: size.height * 0.25, // Adjust position from bottom
          right: size.width * 0.2, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/dog1.png', // Replace with your own image path
              width: 200, // Adjust size as needed
              height: 320,
              fit: BoxFit.fill,
            ),
            onPressed: () {
             showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text('This is the image of your customer.'),
                                  content: Text('Your customer\'s image will change when your growth value reached 50 and 100.\nBut when its health value reaches 0, your customer will die! At each day\'s 0000AM, if health value is greater than 80(80 not included), growth value will increase by 1. \nWhen not sleeping and not fostered, health value will drop by 2 per hour.'),
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

        Positioned(
          bottom: size.height * 0.7, // Adjust position from bottom
          right: size.width * 0.15, // Adjust position from right
          child: Text(
            'Press all the buttons!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),

        Positioned(
          bottom: size.height * 0.65, // Adjust position from bottom
          right: size.width * 0.2, // Adjust position from right
          child: Text(
            'Press on the image of your customer.',
            style: TextStyle(
              fontSize: 16,
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