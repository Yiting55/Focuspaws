// ignore_for_file: unused_import, must_be_immutable, prefer_const_constructors, use_build_context_synchronously, unused_field, prefer_final_fields, prefer_initializing_formals, unnecessary_this, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/achievementbook_page.dart';
import 'package:flutter_application_1/features/pages/bag_page.dart';
import 'package:flutter_application_1/features/pages/calendar_page.dart';
import 'package:flutter_application_1/features/pages/hunt_page.dart';
import 'package:flutter_application_1/features/pages/petshop_page.dart';
import 'package:flutter_application_1/features/pages/settings_page.dart';
import 'package:flutter_application_1/features/pages/timer_page.dart';
import 'package:flutter_application_1/features/pet/achievement.dart';
import 'package:flutter_application_1/features/pet/pet.dart';
import 'package:flutter_application_1/features/pages/healthBar.dart';
import 'package:flutter_application_1/features/alert/alert.dart';
import 'package:flutter_application_1/features/user_auth/login_page.dart';
import 'package:flutter_application_1/features/user_auth/signinorregister_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  Pet pet; 
  User user;
  List<Achievement> achievements;
  bool sleep;
  bool foster;
  DateTime sleepTime;
  DateTime cookTime;
  DateTime fosterTime;

  MainPage(Pet dog, User user, List<Achievement> achievements, bool sleep, bool foster, 
  DateTime sleepTime, DateTime cookTime, DateTime fosterTime, {super.key})
    : pet = dog,
    user = user,
    achievements = achievements,
    sleep = sleep,
    foster = foster,
    sleepTime = sleepTime,
    cookTime = cookTime,
    fosterTime = fosterTime;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int healthValue; // Progress value based on pet's health
  late Timer? _timer; // Timer for updating progress
  late int growthValue;
  late DateTime _lastCookTime = DateTime.now().subtract(const Duration(hours: 7));
  late String image;
  late bool sleep;
  late bool foster;
  DateTime _lastSleepTime = DateTime.now().subtract(const Duration(hours: 12));
  DateTime _lastFosterTime = DateTime.now().subtract(const Duration(days: 8));
  late bool die;
  late List<Achievement> achievements;

  @override
  void initState() {
    super.initState();
    // Initialize progress value with pet's initial health
    healthValue = widget.pet.health ;
    growthValue = widget.pet.growth ;
    _timer = null;
    sleep = widget.sleep;
    foster = widget.foster;
    _lastCookTime = widget.cookTime;
    _lastFosterTime = widget.fosterTime;
    _lastSleepTime = widget.sleepTime;
    die = false;
    achievements = widget.achievements;
    if (sleep == false && foster == false && healthValue > 0) {
      startTimer();
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

  void startTimer(){
    _timer = Timer.periodic(const Duration(hours: 1), (Timer timer) {
      setState(() {
        if (healthValue > 0) {
          healthValue-= 2; 
          Pet pet = Pet(widget.pet.name, healthValue, growthValue);
          savePetAndAchievements(widget.user, pet, this.achievements, this.sleep, this.foster,
          _lastSleepTime,_lastCookTime,_lastFosterTime );
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
      Pet pet = Pet(widget.pet.name, healthValue, growthValue);
      savePetAndAchievements(widget.user, pet, this.achievements, this.sleep, this.foster, 
      _lastSleepTime,_lastCookTime,_lastFosterTime);
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
        sleep = false;
      }
      Pet pet = Pet(widget.pet.name, healthValue, growthValue);
      savePetAndAchievements(widget.user, pet, this.achievements, this.sleep, this.foster, 
      _lastSleepTime,_lastCookTime,_lastFosterTime);
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
    return difference.inSeconds >= 3600*6;
  }

  bool cansleep() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(_lastSleepTime);
    return difference.inHours >= 12;
  }

  bool canfoster() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(_lastFosterTime);
    return difference.inDays >= 7;
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
  Future<void> feed1() async {
    await removeFoodOfLevel('Level 1');
    setState(() {
      if (healthValue >= 95) {
      healthValue = 100;
    } else {
    healthValue += 5;
    }
    Pet pet = Pet(widget.pet.name, healthValue, growthValue);
    savePetAndAchievements(widget.user, pet, this.achievements, sleep, foster, 
    _lastSleepTime,_lastCookTime,_lastFosterTime);}
    );
  }

  Future<void> feed2() async {
    await removeFoodOfLevel('Level 2');
    setState(() {
      if (healthValue >= 90) {
      healthValue = 100;
    } else {
      healthValue += 10;
    }
     Pet pet = Pet(widget.pet.name, healthValue, growthValue);
    savePetAndAchievements(widget.user, pet, this.achievements, sleep, foster, 
    _lastSleepTime,_lastCookTime,_lastFosterTime);
    });
  }

  Future<void> feed3() async {
    await removeFoodOfLevel('Level 3');
    setState(() {
      if (healthValue >= 80) {
        healthValue = 100;
      } else {
      healthValue += 20;
      }
      grow();
      Pet pet = Pet(widget.pet.name, healthValue, growthValue);
      savePetAndAchievements(widget.user, pet, this.achievements,  sleep, foster, 
      _lastSleepTime,_lastCookTime,_lastFosterTime);
    });
  }

  Future<bool> hasFoodOfLevel(String level) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      CollectionReference userFoodCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .collection('foods');

      QuerySnapshot querySnapshot = await userFoodCollection
          .where('level', isEqualTo: level)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    }
    return false;
  }

  Future<void> removeFoodOfLevel(String level) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      CollectionReference userFoodCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('foods');
        
      QuerySnapshot querySnapshot = await userFoodCollection
        .where('level', isEqualTo: level)
        .limit(1)
        .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        int currentQuantity = doc['quantity'];
        if (currentQuantity > 1) {
          await doc.reference.update({'quantity': currentQuantity - 1});
        } else {
          await doc.reference.delete();
        }
      }
    }
  }

  void grow() {
    setState(() {
      if (growthValue >= 149) {
        growthValue = 150;
      } else {
        growthValue += 1;
      }
      Pet pet = Pet(widget.pet.name, healthValue, growthValue);
      savePetAndAchievements(widget.user, pet, this.achievements,  sleep, foster, 
      _lastSleepTime,_lastCookTime,_lastFosterTime);
      if (growthValue == 150) {
          if (!exist(widget.pet)) {
            this.achievements.add(Achievement(petName: widget.pet.name));
          }
          Pet pet = Pet(widget.pet.name, healthValue, growthValue);
          savePetAndAchievements(widget.user, pet, this.achievements,  sleep, foster, 
          _lastSleepTime,_lastCookTime,_lastFosterTime);
      }
    });
  }

  bool exist(Pet pet){
    for (Achievement achi in achievements) {
      if (achi.petName == pet.name) {
        return true;
      }
    }
    return false;
  }

  void addAchievement(String petName) async {
      Achievement newAchievement = Achievement(petName: petName);
      setState(() {
        achievements.add(newAchievement);
      });
    }
 // Function to load achievement book

  @override
  Widget build(BuildContext context) {
    String image;
    if (growthValue < 50 && growthValue >= 0)  {
      if (widget.pet.name == "Corgi") {
        image = 'assets/onboarding/Corgi1.png';
      } else if (widget.pet.name == "Golden Retriever") {
        image = 'assets/onboarding/golden1.png';
      } else {
        image = 'assets/onboarding/samo1.png';
      }
    } else if (growthValue >= 50 && growthValue < 100) {
      if (widget.pet.name == "Corgi") {
        image = 'assets/onboarding/Corgi2.png';
      } else if (widget.pet.name == "Golden Retriever") {
        image = 'assets/onboarding/golden2.png';
      } else {
        image = 'assets/onboarding/samo2.png';
      }
    } else {
      if (widget.pet.name == "Corgi") {
        image = 'assets/onboarding/Corgi3.png';
      } else if (widget.pet.name == "Golden Retriever") {
        image = 'assets/onboarding/golden3.png';
      } else {
        image = 'assets/onboarding/samo3.png';
      }
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

        // hunt button
        Positioned(
          bottom: size.height * 0.2, // Adjust position from bottom
          right: size.width * 0.14, // Adjust position from right
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
            },
            iconSize: 300,
          ),
        ),

        // logout button
        // Positioned(
        //   top: size.height * 0.1,
        //   right: size.width * 0.03,
        //   child: _logOutButton()
        // ),

        // Positioned(
        //   top: size.height * 0.15, // Adjust position from bottom
        //   right: size.width * 0.01, // Adjust position from right
        //   child: IconButton(
        //     icon: Image.asset(
        //       'assets/onboarding/functions/light.png', // Replace with your own image path
        //       width: 50.0, // Adjust size as needed
        //       height: 50.0,
        //       fit: BoxFit.fill,
        //     ),
        //     onPressed: () {
        //       // Handle button 2 press
        //     },
        //     iconSize: 300,
        //   ),
        // ),

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
                      content: Text('Can foster again in ${(7 - (DateTime.now().difference(_lastFosterTime).inDays))} days.'),
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
              Pet pet = Pet(widget.pet.name, healthValue, growthValue);
              savePetAndAchievements(widget.user, pet, this.achievements, this.sleep, this.foster, 
              _lastSleepTime,_lastCookTime,_lastFosterTime);
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
                      content: Text('Can sleep again in ${(12 - (DateTime.now().difference(_lastSleepTime).inHours))} hours.'),
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
              Pet pet = Pet(widget.pet.name, healthValue, growthValue);
              savePetAndAchievements(widget.user, pet, this.achievements, this.sleep, this.foster, 
              _lastSleepTime,_lastCookTime,_lastFosterTime);
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
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => BagPage()),
              );
              // Handle button 2 press
            },
            iconSize: 300,
          ),
        ),

        // achievement book button
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
                MaterialPageRoute(builder: (context) => AchievementBookPage(user: widget.user, achievements: this.achievements)),
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
              showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              builder: (BuildContext context) {
                return Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
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
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // for level 1
                          TextButton(
                            onPressed: () async {
                              // pet dead
                              if (healthValue == 0) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                  title: Text('Your customer is dead'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Petshop(widget.user, this.achievements);
                                      },
                                    ),
                                  ],
                                  ),
                                );
                              // in sleep
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
                              // in foster 
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
                              // can cook
                              } else if (canCook()) {
                                // check whether has food of this level                                
                                if (!(await hasFoodOfLevel("Level 1"))) {
                                  showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: Text('Cannot Feed'),
                                    content: Text('There is no Level 1 food available.'),
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
                                } else {
                                  _saveLastCookTime();
                                  Navigator.pop(context); // Close modal sheet
                                  feed1();
                                }
                              // within time limit 
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
                            child: Column(
                              children: [
                                Text(
                                  'Level 1',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                                SizedBox(height: 5.0),
                                Text(
                                  '(Health + 5)',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 50, 50, 50),
                                    fontSize: 14,
                                  )),
                                SizedBox(height: 50.0),
                              ],
                            ),
                          ),

                          // for level 2
                          TextButton(
                            onPressed: () async {
                              if (sleep == true) {
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
                              
                              } else if (canCook()) {
                                if (!(await hasFoodOfLevel("Level 2"))) {
                                  showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: Text('Cannot Feed'),
                                    content: Text('There is no Level 2 food available.'),
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
                                } else {
                                  _saveLastCookTime();
                                  Navigator.pop(context); // Close modal sheet
                                  feed2();
                                }
                              } 
                    
                              else {
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
                            child: Column(
                              children: [
                                Text(
                                  'Level 2',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                                SizedBox(height: 5.0),
                                Text(
                                  '(Health + 10)',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 50, 50, 50),
                                    fontSize: 14,
                                  )),
                                SizedBox(height: 50.0),
                              ],
                            ),
                          ),

                          // level 3
                          TextButton(
                            onPressed: () async {
                              if (sleep == true) {
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
                              } else if (canCook()) {
                                if (!(await hasFoodOfLevel("Level 3"))) {
                                  showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: Text('Cannot Feed'),
                                    content: Text('There is no Level 3 food available.'),
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
                                } else {
                                  _saveLastCookTime();
                                  Navigator.pop(context); 
                                  feed3();
                                }
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
                            child: Column(
                              children: [
                                Text(
                                  'Level 3',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                                SizedBox(height: 5.0),
                                Text(
                                  '(Health + 20\nGrowth + 1)',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 50, 50, 50),
                                    fontSize: 14,
                                  )),
                                SizedBox(height: 30.0),
                              ],
                            ),
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
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              // Handle button 2 press
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
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );
              // Handle button 2 press
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

        // dog image
        Center(
          child: Positioned(
            child: Image.asset(image, width: 300, height: 250,)
          ),
        ),

        // shop button
        if (die || growthValue == 150)
              Positioned(
                top: size.height * 0.3, 
                left: size.width * 0.02, 
                child: IconButton(
                  icon: Image.asset(
                    'assets/onboarding/shop.png', 
                    width: 50, 
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                  onPressed: () {
                  Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => Petshop(widget.user, widget.achievements)),
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
          top: size.height * 0.103, // Adjust position from bottom
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
      ],
    );
  }
}
