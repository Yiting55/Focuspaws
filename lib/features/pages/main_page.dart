// ignore_for_file: unused_import, must_be_immutable, prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/bag_page.dart';
import 'package:flutter_application_1/features/pages/calendar_page.dart';
import 'package:flutter_application_1/features/pages/hunt_page.dart';
import 'package:flutter_application_1/features/pages/petshop.dart';
import 'package:flutter_application_1/features/pages/timer_page.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:flutter_application_1/features/pages/healthBar.dart';
import 'package:flutter_application_1/features/alert/alert.dart';
import 'package:flutter_application_1/features/user_auth/login_page.dart';
import 'package:flutter_application_1/features/user_auth/signinorregister_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/features/pages/petshop.dart';
import 'package:flutter_application_1/features/pages/achievement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  Pet pet; 
  User user;

  MainPage(Pet dog, User user, {super.key})
    : pet = dog,
    this.user = user;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double healthValue; // Progress value based on pet's health
  late Timer? _timer; // Timer for updating progress
  late double growthValue;
  late DateTime _lastCookTime = DateTime.now().subtract(const Duration(hours: 7));
  late String image;
  late bool sleep;
  late bool foster;
  DateTime _lastSleepTime = DateTime.now().subtract(const Duration(hours: 12));
  DateTime _lastFosterTime = DateTime.now().subtract(const Duration(days: 8));
  late bool die;

  @override
  void initState() {
    super.initState();
    // Initialize progress value with pet's initial health
    healthValue = widget.pet.health / 100 * 100;
    growthValue = widget.pet.growth / 100 * 100;
    sleep = false;
    foster = false;
    die = false;
    startTimer();
    }


    void startTimer(){
    _timer = Timer.periodic(const Duration(hours: 1), (Timer timer) {
      setState(() {
        if (healthValue > 0) {
          healthValue-= 2; 
          if (healthValue <= 40) {
            sendNotification();
          }
          if (sleep == true) {
            timer.cancel();
            restartTimerAfter8Hours();
          }
          if (foster == true) {
            timer.cancel();
            restartTimerAfter10days();
          }
        } else {
          timer.cancel(); // Stop the timer when progress value reaches 0
        }
      });
    });
    }

  void restartTimerAfter8Hours() {
    Future.delayed(Duration(hours: 8)).then((_) {
      if (sleep) {
        setState(() { // Reset time
          startTimer(); // Start timer again
        });
      }
    });
  }

  void restartTimerAfter10days(){
    Future.delayed(Duration(days: 10)).then((_) {
      if (foster) {
        setState(() { // Reset time
          startTimer(); // Start timer again
        });
      }
    });
  }

  void beSlept() {
    setState(() {
      sleep = !sleep;
      if (!sleep) {
        startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void wake() {
    setState(() {
      sleep = false;
    });
  }

  void beFostered() {
    setState(() {
      foster = !foster;
      if (!foster) {
        startTimer();
      } else {
        _timer?.cancel();
        healthValue = 80;
      }
    });

  }

  void back() {
    setState(() {
      foster = false;
    });
  }


  void _saveLastCookTime() {
    setState(() {
      _lastCookTime = DateTime.now();
    });
  }

  void _saveLastSleepTime() {
    setState(() {
      _lastSleepTime = DateTime.now();
    });
  }

  void _saveLastFosterTime() {
    setState(() {
      _lastFosterTime = DateTime.now();
    });
  }

  bool canCook() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(_lastCookTime);
    return difference.inSeconds >= 1;
  }

  bool cansleep() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(_lastSleepTime);
    return difference.inHours >= 12;
  }

  bool canfoster() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(_lastFosterTime);
    return difference.inHours >= 12;
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
    _timer?.cancel(); // Cancel the timer to avoid memory leaks
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
      if (growthValue >= 149) {
        growthValue = 150;
      }
      growthValue += 50;
      if (growthValue == 150) {
            _checkAndAddPet();
      }
    });
  }

  Future<bool> _doesPetExist(User user, String petType) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('achievement_book')
        .where('type', isEqualTo: petType)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> _checkAndAddPet() async {
    bool petExists = await _doesPetExist(widget.user, widget.pet.runtimeType.toString());
    if (!petExists) {
      addPetToAchievementBook(widget.user, widget.pet);
    }
  }

  Future<void> addPetToAchievementBook(User user, Pet pet) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic> info = {'type': pet.name,
      'dateRaised': DateTime.now().toIso8601String()};
  await firestore.collection('users').doc(user.uid).collection('achievement_book').add(info);
}

// Function to load achievement book

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
    String image;
    if (growthValue < 50 && growthValue >= 0)  {
      image = widget.pet.image1;
    } else if (growthValue >= 50 && growthValue < 100) {
      image = widget.pet.image2;
    } else {
      image = widget.pet.image3;
    } 
    if (healthValue == 0) {
      image = widget.pet.dead;
      die = true;
    }
    if (sleep == true) {
      image = "assets/onboarding/sleep.png";
    }
    if (foster == true) {
      image = "assets/onboarding/foster.png";
    }
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
              if (! die) {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => HuntPage()));
              } else {
                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text('Your customer is dead'),
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
              if (healthValue == 0) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text('Your customer is dead'),
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
              else if (foster == false && canfoster()) {
                beFostered();
                _saveLastFosterTime();
              } 
              else if (foster ==  true) {
                back();
                startTimer();
              } 
              else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Cannot Foster Yet'),
                      content: Text('Can foster again in ${(7 - (DateTime.now().difference(_lastCookTime).inDays))} days.'),
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
              if (healthValue == 0) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text('Your customer is dead'),
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
              else if (foster == true) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Cannot Sleep'),
                      content: Text('Your customer is fostered'),
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
              else if (cansleep() && sleep == false) {
                beSlept();
                _saveLastSleepTime();
              } else if (sleep == true) {
                wake();
                startTimer();
              } 
              else if (!cansleep() || foster == false){
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Cannot Sleep Yet'),
                      content: Text('Can sleep again in ${(12 - (DateTime.now().difference(_lastCookTime).inHours))} hours.'),
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
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AchievementBookPage(user: widget.user)),
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
                              if (healthValue == 0) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text('Your customer is dead'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Petshop(widget.user);
                                      },
                                    ),
                                  ],
                                  ),
                                );
                              } else if (sleep == true) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text('Cannot Feed'),
                                  content: Text('Your customer is sleeping'),
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
                              } else if (foster == true) {
                                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Cannot Feed'),
                      content: Text('Your customer was fostered.'),
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
                              else if (canCook()) {
                                _saveLastCookTime();
                              // Action for Button 1
                                Navigator.pop(context); // Close modal sheet
                              // Add your custom action here
                                feed1();
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
                            child: Text('Set 1'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (canCook()) {
                                _saveLastCookTime();
                              // Action for Button 1
                                Navigator.pop(context); // Close modal sheet
                              // Add your custom action here
                                feed2();
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
                            child: Text('Set 2'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (canCook()) {
                                _saveLastCookTime();
                              // Action for Button 1
                                Navigator.pop(context); // Close modal sheet
                              // Add your custom action here
                                feed3();
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
                            child: Text('Set 3'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
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
          right: size.width * 0.08,
          child: Image.asset(image, width: 300, height: 250,)
        ),

        if (die || growthValue == 150)
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
             Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => Petshop(widget.user)),
              );
            },
            iconSize: 400,
          ),
        ),
      ],
    );
  }
}