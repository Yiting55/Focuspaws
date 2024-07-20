// ignore_for_file: prefer_const_constructors, unused_import

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_application_1/features/onboarding/onboarding_items.dart";
import "package:flutter_application_1/features/pages/main_page.dart";
import "package:flutter_application_1/features/pages/petshop_page.dart";
import "package:flutter_application_1/features/pet/pet.dart";
// import "package:flutter_application_1/features/pages/home_page.dart";
import "package:flutter_application_1/features/user_auth/login_page.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import "package:shared_preferences/shared_preferences.dart";

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override 
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastPage = false;

  void setOnboardingStatus() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    pres.setBool("onboarding", true);
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 179, 57),
      bottomSheet: Container(
        color: Color.fromARGB(255, 255, 179, 57),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: isLastPage? getStarted() : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            //skip button
            TextButton(
              onPressed: () => pageController.jumpToPage(controller.items.length-1), 
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                ))),
            
            //scroll page indicator
            SmoothPageIndicator(
              controller: pageController, 
              count: controller.items.length,
              onDotClicked: (index) => pageController.animateToPage(
                index, 
                duration: const Duration(milliseconds: 600), 
                curve: Curves.easeIn),
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 14,
                activeDotColor: Colors.white,
              ),
            ),

            //next button
            TextButton(
              onPressed: () => pageController.nextPage(
                duration: const Duration(milliseconds: 600), 
                curve: Curves.easeIn), 
              child: const Text(
                "Next",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                )),
            ),
          ],
        ),
      ),

      //page content 
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: PageView.builder(
          onPageChanged: (index){
            setState(() => isLastPage = (controller.items.length - 1 == index));
          },
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                ClipOval(
                  //borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    controller.items[index].image,
                    height: 320,
                    width: 320,
                    fit: BoxFit.cover,
                    ),
                ),
                
                const SizedBox(height: 40),
                
                Text(
                  controller.items[index].title, 
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),),
                
                const SizedBox(height: 15),
                
                Text(
                  controller.items[index].description,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'OpenSans',
                    color: Color.fromARGB(255, 41, 41, 41)
                    ),
                  textAlign: TextAlign.center,
                ),
              ],);
          },)
      )
    );
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 255, 130, 21),
      ),
      width: MediaQuery.of(context).size.width * .9,
      height: 60,
      child: TextButton(
        onPressed: () async {
          setOnboardingStatus();

          //if(!mounted)return;
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context){
              Pet dog = Pet();
              return MainPage(dog);
            })); 
        },
        
        child: const Text(
          "Get Started", 
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold),))
    );
  }
}

