// ignore_for_file: unused_import
import 'dart:ui';
import 'dart:async';
import 'dart:core';

class Pet {
  int health;
  int growth;
  bool alive;
  bool asleep;
  String image1;
  String image2;
  String image3;
  String dead;
  String? type;
  DateTime? dateRaised;
  String name;

  Pet(String name, int health, int growth) 
    : health = health,
      growth = growth,
      asleep = false,
      alive = true,
      this.name = name,
      image1 = 'assets/onboarding/puppy_kitty.jpeg',
      image2 = 'assets/onboarding/puppy_kitty.jpeg',
      image3 = 'assets/onboarding/puppy_kitty.jpeg',
      dead = 'assets/onboarding/dead.png';

   Map<String, dynamic> toMap() {
    return {
      'name': name,
      'health': health,
      'growth': growth,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      map['name'],
      map['health'],
      map['growth'],
    );
  }

}
