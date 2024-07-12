// ignore_for_file: unused_import, must_be_immutable, prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/bag_page.dart';
import 'package:flutter_application_1/features/pages/calendar_page.dart';
import 'package:flutter_application_1/features/pages/hunt_page.dart';
import 'package:flutter_application_1/features/pages/timer_page.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:flutter_application_1/features/pages/healthBar.dart';
import 'package:flutter_application_1/features/alert/alert.dart';
import 'package:flutter_application_1/features/user_auth/login_page.dart';
import 'package:flutter_application_1/features/user_auth/signinorregister_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  Pet pet; 

  MainPage(Pet dog, {super.key})
    : pet = dog;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double healthValue; // Progress value based on pet's health
  late Timer _timer; // Timer for updating progress
  late double growthValue;
  late DateTime _lastCookTime = DateTime.now().subtract(const Duration(hours: 7));

  @override
  void initState() {
    super.initState();
    // Initialize progress value with pet's initial health
    healthValue = widget.pet.health / 100 * 100;
    growthValue = widget.pet.growth / 100 * 100;

    // Start a timer to update progress value periodically
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (healthValue > 0) {
          healthValue-= 5; 
          if (healthValue <= 40) {
            sendNotification();
          }
        } else {
          timer.cancel(); // Stop the timer when progress value reaches 0
        }
      });
    });
    dailyGrow();

  }


  void _saveLastCookTime() {
    setState(() {
      _lastCookTime = DateTime.now();
    });
  }

  bool canCook() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(_lastCookTime);
    return difference.inHours >= 6;
  }

  void dailyGrow() {
    if (healthValue > 80) {
      DateTime now = DateTime.now();
      DateTime midnight = DateTime(now.year, now.month, now.day + 1); // Next midnight
      Duration durationUntilMidnight = midnight.difference(now);
      Timer.periodic(durationUntilMidnight, (Timer timer) {
        setState(() {
          grow(); // Increase health by 10
        });
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  // Method to increase progress value
  void feed1() {
    setState(() {
      if (healthValue >= 95) {
      healthValue = 100;
    } else {
    healthValue += 5;
    }
    });
  }

  void feed2() {
    setState(() {
      if (healthValue >= 90) {
      healthValue = 100;
    } else {
      healthValue += 10;
    }
    });
  }

  void feed3() {
    setState(() {
      if (healthValue >= 80) {
      healthValue = 100;
    } else {
    healthValue += 20;
    }
    grow();
    });
  }

  void grow() {
    setState(() {
      if (growthValue >= 99) {
        growthValue = 100;
      }
      growthValue++;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SigninOrRegisterPage()));
  }

  Widget _logOutButton() {
    return IconButton(
      onPressed: () => _logout(context),
      color: Colors.black, 
      icon: const Icon(Icons.logout),
      iconSize: 30,
    );
  }

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
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => HuntPage()));
              // Handle button 2 press
            },
            iconSize: 300,
          ),
        ),

        // logout button
        Positioned(
          top: size.height * 0.1,
          right: size.width * 0.03,
          child: _logOutButton()
        ),

        Positioned(
          top: size.height * 0.15, // Adjust position from bottom
          right: size.width * 0.01, // Adjust position from right
          child: IconButton(
            icon: Image.asset(
              'assets/onboarding/functions/light.png', // Replace with your own image path
              width: 50.0, // Adjust size as needed
              height: 50.0,
              fit: BoxFit.fill,
            ),
            onPressed: () {
              // Handle button 2 press
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
              // Handle button 2 press
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
              // Handle button 2 press
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
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => BagPage()),
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
              // Handle button 2 press
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
              if (canCook()) { 
                _saveLastCookTime();
               showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Choose an option:',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Action for Button 1
                              Navigator.pop(context); // Close modal sheet
                              // Add your custom action here
                              feed1();
                            },
                            child: Text('Set 1'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Action for Button 2
                              Navigator.pop(context); // Close modal sheet
                              // Add your custom action here
                              feed2();
                            },
                            child: Text('Set 2'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Action for Button 3
                              Navigator.pop(context); // Close modal sheet
                              // Add your custom action here
                              feed3();
                            },
                            child: Text('Set 3'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                title: Text('Cannot Feed Yet'),
                content: Text('You can feed again in ${(6 - (DateTime.now().difference(_lastCookTime).inHours))} hours.'),
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
            }
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
              // Handle button 2 press
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
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => CalendarPage()),
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
          bottom: size.height * 0.3,
          right: size.width * 0.25,
          child: Image.asset(widget.pet.image)
          ),
      ],
    );
  }
}