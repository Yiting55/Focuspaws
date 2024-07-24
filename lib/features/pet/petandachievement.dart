import 'package:flutter_application_1/features/pet/achievement.dart';
import 'package:flutter_application_1/features/pet/pet.dart';

class PetAndAchievements {
  final Pet? pet;
  final List<Achievement> achievements;
  bool sleep;
  bool foster;
  DateTime sleepTime;
  DateTime cookTime;
  DateTime fosterTime;


  PetAndAchievements({required this.pet, required this.achievements, 
  required this.sleep, required this.foster, 
  required this.sleepTime, required this.cookTime, required this.fosterTime});

   Map<String, dynamic> toMap() {
    return {
      'pet': pet?.toMap(),
      'achievements': achievements.map((a) => a.toMap()).toList(),
      'sleep': sleep,
      'foster': foster,
      'sleepTime': sleepTime.toIso8601String(),
      'cookTime': cookTime.toIso8601String(),
      'fosterTime': fosterTime.toIso8601String(),
    };
  }

  // Factory method to create an instance from a map
  factory PetAndAchievements.fromMap(Map<String, dynamic> map) {
    return PetAndAchievements(
      pet: map['pet'] != null ? Pet.fromMap(map['pet']) : null,
      achievements: (map['achievements'] as List).map((a) => Achievement.fromMap(a)).toList(),
      sleep: map['sleep'] ?? false,
      foster: map['foster'] ?? false,
      sleepTime: DateTime.parse(map['sleepTime']),
      cookTime: DateTime.parse(map['cookTime']),
      fosterTime: DateTime.parse(map['fosterTime']),
    );
  }
}