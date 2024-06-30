// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_local_variable

import 'dart:async' show Timer;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pet/pet.dart';

class HealthBarWidget extends StatefulWidget {
  Pet dog;

  HealthBarWidget(this.dog, {super.key});

  @override
  State<HealthBarWidget> createState() => _HealthBarWidgetState();
}

class _HealthBarWidgetState extends State<HealthBarWidget> {
  late int progressValue; // Initial progress value
  late Timer _timer; // Timer for decreasing progress

  @override
  void initState() {
    super.initState();
    progressValue = widget.dog.health;
    // Start a timer to decrease progress value every second
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (progressValue > 0) {
          progressValue -= 1; // Decrease progress value by 0.1 every second
        } else {
          timer.cancel(); // Stop the timer when progress value reaches 0
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
        Positioned(
          child: 
          Container(
              width: 200.0, // Adjust the width of the progress bar container
              height: 20, // Adjust the height of the progress bar
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
        ),

        Positioned(
          child: Container(
            width: 200.0 * widget.dog.health / 100 , // Adjust the width of the progress bar
            height: 20.0, // Adjust the height of the progress bar
            decoration: BoxDecoration(
              color: Color.fromARGB(146, 255, 0, 0),
              borderRadius: BorderRadius.circular(10.0),
              ),
          ),
        ),
        ],
      ),
    );
  }
}