// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/timer_page.dart';

class HuntPage extends StatelessWidget {
  const HuntPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
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
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Select Food Level',
            style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontFamily: 'Open Sans'
          ),),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: _page(context),
      ),
    );
  }

  Widget _page(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _chooseText(),
            SizedBox(height: 36.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _levelButton(context, 'assets/onboarding/level1food.png', 'Level 1', 30),
                SizedBox(width: 15.0),
                _levelButton(context, 'assets/onboarding/level2food.png', 'Level 2', 60),
                SizedBox(width: 15.0),
                _levelButton(context, 'assets/onboarding/level3food.png', 'Level 3', 90),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chooseText() {
    return Column(
      children: [
        Text(
          'Choose one Level to start.',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Open Sans'
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.0),
        Text(
          '*below shows the focus time requirement',
          style: TextStyle(
            fontSize: 16.0,
            color: const Color.fromARGB(255, 50, 50, 50),
            fontFamily: 'Open Sans'
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _levelButton(BuildContext context, String imagePath, String level, int minTime) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimerPage(level: level, minTime: minTime)),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 3 - 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, height: 80.0),
                SizedBox(height: 10.0),
                Text(
                  level,
                  style: TextStyle(
                    fontSize: 20.0, 
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans'),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Min $minTime minutes',
                  style: TextStyle(
                    fontSize: 12.0, 
                    color: const Color.fromARGB(255, 50, 50, 50),
                    fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
      )
    ));
  }
}
