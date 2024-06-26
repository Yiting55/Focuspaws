class FocusActivity {
  final String name;
  final int duration;
  final bool isSuccess;

  FocusActivity({
    required this.name,
    required this.duration,
    required this.isSuccess,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'duration': duration,
      'isSuccess': isSuccess,
    };
  }
}