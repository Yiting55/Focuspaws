// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/bag/food_item.dart';

class FoodPage extends StatefulWidget {
  final String level;
  final List<FoodItem> foodItems;

  const FoodPage({super.key, required this.level, required this.foodItems});
  
  @override 
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
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
            '${widget.level} Food',
            style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontFamily: 'Open Sans'
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: _foodList(),
      ),
    );
  }

  Widget _foodList() {
    if (widget.foodItems.isEmpty) {
      return Center(
        child: Text(
          'No food available in ${widget.level}.',
          style: TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontFamily: 'Open Sans'
          ),
        ),
      );
    } 
    return ListView.builder(
      itemCount: widget.foodItems.length,
      itemBuilder: (context, index) {
        var foodItem = widget.foodItems[index];
        return ListTile(
          leading: Image.asset('assets/onboarding/level${widget.level.split(' ')[1]}food.png'),
          title: Text(foodItem.level),
          subtitle: Text(
            'Quantity: ${foodItem.quantity}\nExpires on: ${foodItem.expiryDate.toLocal().toString().split(' ')[0]}',
          ),
        );
      },
    );    
  }
}