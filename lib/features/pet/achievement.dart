class Achievement {
  final String petName;

  Achievement({required this.petName});

  Map<String, dynamic> toMap() {
    return {
      'petName': petName,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      petName: map['petName'],
    );
  }

  String loadPicture(String name) {
    if (name == "Corgi") {
      return "assets/onboarding/Corgi.png";
    } else if (name == "Golden Retriever") {
      return "assets/onboarding/golden.png";
    }
    return "assets/onboarding/samo.png";
  }
}



