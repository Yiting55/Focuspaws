// ignore_for_file: unused_import

import 'package:flutter_application_1/features/pet/set.dart';
import 'dart:async';

class Pet {
  int health;
  int growth;
  bool alive;
  bool asleep;
  String image; 

  Pet() 
    : health = 80,
      growth = 0,
      asleep = false,
      alive = true,
      image = 'assets/onboarding/functions/dog1.png';
    
  void sleep() {
    asleep = true;
  }

  void wake() {
    asleep = false;
  }
}