import 'package:flutter_application_1/features/onboarding/onboarding_info.dart';

class OnboardingItems{
  List<OnboardingInfo> items = [
    OnboardingInfo(
      title: "Understand Their Burdens", 
      description: "Every year, many cats and dogs return to their respective stars, carrying the weight of the pain and sorrow they have endured during their lifetimes. These burdens cause great distress to their souls, causing them to suffer from worse degeneration.",
      image: "assets/onboarding/flying_dog.jpeg"),
    
    OnboardingInfo(
      title: "Your Healing Mission", 
      description: "However, an immature soul cannot reincarnate and return to earth. Your mission is to heal these souls and release their burdens, allowing them to grow up and mature until they are ready for reincarnation.", 
      image: "assets/onboarding/staff.jpeg"),
    
    OnboardingInfo(
      title: "Choose a Soul to Guide", 
      description: "Begin your work by choosing a puppy or kitten and help guide their souls towards healing!", 
      image: "assets/onboarding/puppy_kitty.jpeg"),
  ];
}