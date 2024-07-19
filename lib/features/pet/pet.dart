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

  Pet() 
    : health = 80,
      growth = 0,
      asleep = false,
      alive = true,
      name = 'pet',
      image1 = 'assets/onboarding/puppy_kitty.jpeg',
      image2 = 'assets/onboarding/puppy_kitty.jpeg',
      image3 = 'assets/onboarding/puppy_kitty.jpeg',
      dead = 'assets/onboarding/dead.png';

  static Pet fromMap(Map<String, dynamic> map){
    return Pet();
  }

}

class GoldenRetriever extends Pet {
  GoldenRetriever() {
    image1 = 'assets/onboarding/golden1.png';
    image2 = 'assets/onboarding/golden2.png';
    image3 = 'assets/onboarding/golden3.png';
    name = "GoldenRetriever";
  }

  static GoldenRetriever fromMap(Map<String, dynamic> map){
    return GoldenRetriever();
  }

}

class Corgi extends Pet {
  Corgi() {
    image1 = 'assets/onboarding/Corgi1.png';
    image2 = 'assets/onboarding/Corgi2.png';
    image3 = 'assets/onboarding/Corgi3.png';
    name = 'Corgi';
  }

  static Corgi fromMap(Map<String, dynamic> map){
    return Corgi();
  }
}

class Samoyed extends Pet {
  Samoyed() {
    image1 = 'assets/onboarding/samo1.png';
    image2 = 'assets/onboarding/samo2.png';
    image3 = 'assets/onboarding/samo3.png';
    name = 'Samoyed';
  }

  static Samoyed fromMap(Map<String, dynamic> map){
    return Samoyed();
  }
}