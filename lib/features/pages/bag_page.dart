// ignore_for_file: prefer_const_constructors, unused_field, avoid_types_as_parameter_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/bag/food_item.dart';
import 'package:flutter_application_1/features/pages/food_page.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});
  
  @override 
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  late Future<Map<String, List<FoodItem>>> _foodItemsFuture;

  @override
  void initState() {
    super.initState();
    _foodItemsFuture = _fetchFoodItems();
  }

  Future<Map<String, List<FoodItem>>> _fetchFoodItems() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return {'Level 1': [], 'Level 2': [], 'Level 3': []};
    }

    CollectionReference userFoodCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('foods');

    QuerySnapshot querySnapshot = await userFoodCollection.get();
    Map<String, List<FoodItem>> foodLevels = {
      'Level 1': [],
      'Level 2': [],
      'Level 3': [],
    };

    DateTime today = DateTime.now();

    for (var doc in querySnapshot.docs) {
      String level = doc['level'];
      int quantity = doc['quantity'];
      DateTime expiryDate = (doc['expiryDate'] as Timestamp).toDate();
      
      if (expiryDate.isBefore(today)) {
        continue;
      }

      if (foodLevels.containsKey(level)) {
        foodLevels[level]?.add(FoodItem(
          icon: Icons.fastfood,
          level: level,
          quantity: quantity,
          expiryDate: expiryDate,
        ));
      }
    }
    return foodLevels;
  }

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
            'Bag',
            style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontFamily: 'Open Sans'
          ),),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(child: _page()),
      ),
    );
  }

  Widget _page() {
    return FutureBuilder<Map<String, List<FoodItem>>>(
      future: _foodItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator()
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _emptyBag();
        }

        var foodLevels = snapshot.data!;
        
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _levelBox(context, foodLevels['Level 1'] ?? [], 'Level 1', 'assets/onboarding/level1food.png'),
                SizedBox(height: 15.0),
                _levelBox(context, foodLevels['Level 2'] ?? [], 'Level 2', 'assets/onboarding/level2food.png'),
                SizedBox(height: 15.0),
                _levelBox(context, foodLevels['Level 3'] ?? [], 'Level 3', 'assets/onboarding/level3food.png'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _emptyBag() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _levelBox(context, [], 'Level 1', 'assets/onboarding/level1food.png'),
            SizedBox(height: 15.0),
            _levelBox(context, [], 'Level 2', 'assets/onboarding/level2food.png'),
            SizedBox(height: 15.0),
            _levelBox(context, [], 'Level 3', 'assets/onboarding/level3food.png'),
          ],
        ),
      ),
    );
  }

  Widget _levelBox(BuildContext context, List<FoodItem> foodItems, String level, String imagePath) {
    int totalQuantity = foodItems.fold(0, (sum, item) => sum + item.quantity);
    String expiryDate = '--';
    bool isExpiringToday = false;
    DateTime today = DateTime.now();
    DateTime endOfToday = DateTime(today.year, today.month, today.day, 23, 59, 59);

    if (foodItems.isNotEmpty) {
      DateTime mostRecentExpiryDate = foodItems
          .map((item) => item.expiryDate)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      expiryDate = mostRecentExpiryDate.toLocal().toString().split(' ')[0];
      if (mostRecentExpiryDate.isAfter(today) && mostRecentExpiryDate.isBefore(endOfToday)) {
        isExpiringToday = true;
      }
    }

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => FoodPage(level: level, foodItems: foodItems))
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
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
                    fontFamily: 'Open Sans',
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Total quantity: $totalQuantity',
                  style: TextStyle(
                    fontSize: 16.0, 
                    color: const Color.fromARGB(255, 50, 50, 50),
                    fontFamily: 'Open Sans',
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Earliest expires on: $expiryDate',
                  style: TextStyle(
                    fontSize: 16.0, 
                    color: const Color.fromARGB(255, 50, 50, 50),
                    fontFamily: 'Open Sans',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
