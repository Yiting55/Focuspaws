import 'package:cloud_firestore/cloud_firestore.dart';

class FocusActivity {
  final String name;
  final int duration;
  final bool isSuccess;
  final DateTime timestamp;
  final String level;

  FocusActivity({
    required this.name,
    required this.duration,
    required this.isSuccess,
    required this.timestamp,
    required this.level,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'duration': duration,
      'isSuccess': isSuccess,
      'timestamp': DateTime(timestamp.year, timestamp.month, timestamp.day),
      'level': level,
    };
  }

  factory FocusActivity.fromMap(Map<String, dynamic> map) {
    return FocusActivity(
      name: map['name'], 
      duration: map['duration'], 
      isSuccess: map['isSuccess'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      level: map['level'],
    );
  }
}