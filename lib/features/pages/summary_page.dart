// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/focus_activity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SummaryPage extends StatelessWidget {
  final DateTime date;

  const SummaryPage({super.key, required this.date});

  Map<String, Map<String, int>> _getWeeklyData(List<FocusActivity> events) {
    Map<String, Map<String, int>> weeklyData = {
      '1': {'Level1': 0, 'Level2': 0, 'Level3': 0}, // Monday
      '2': {'Level1': 0, 'Level2': 0, 'Level3': 0}, // Tuesday
      '3': {'Level1': 0, 'Level2': 0, 'Level3': 0}, // Wednesday
      '4': {'Level1': 0, 'Level2': 0, 'Level3': 0}, // Thursday
      '5': {'Level1': 0, 'Level2': 0, 'Level3': 0}, // Friday
      '6': {'Level1': 0, 'Level2': 0, 'Level3': 0}, // Saturday
      '7': {'Level1': 0, 'Level2': 0, 'Level3': 0}, // Sunday
    };

    for (var event in events) {
      String day = event.timestamp.weekday.toString();
      switch (event.level) {
        case 'Level1': // Adjusted to match Firestore data
          weeklyData[day]!['Level1'] = (weeklyData[day]!['Level1'] ?? 0) + 1;
          break;
        case 'Level2': // Adjusted to match Firestore data
          weeklyData[day]!['Level2'] = (weeklyData[day]!['Level2'] ?? 0) + 1;
          break;
        case 'Level3': // Adjusted to match Firestore data
          weeklyData[day]!['Level3'] = (weeklyData[day]!['Level3'] ?? 0) + 1;
          break;
      }
    }
    return weeklyData;
  }

  Future<List<FocusActivity>> _fetchFocusActivities() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      CollectionReference activities = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('allFocusActivity');

      QuerySnapshot snapshot = await activities.get();
      
      return snapshot.docs
          .map((doc) => FocusActivity.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
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
          title: Text('Focus Summary'),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(child: _page()),
      ),  
    );
  }

  Widget _page() {
    return FutureBuilder<List<FocusActivity>>(
      future: _fetchFocusActivities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          List<FocusActivity> events = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                _stackedBarChart(events),
                const SizedBox(height: 30),
                _circularProgressChart(events),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _stackedBarChart(List<FocusActivity> events) {
    Map<String, Map<String, int>> weeklyData = _getWeeklyData(events);
    List<BarChartGroupData> barGroups = [];

    weeklyData.forEach((day, data) {
      barGroups.add(BarChartGroupData(
        x: int.parse(day),
        barRods: [
          BarChartRodData(
            toY: data['Level1']!.toDouble(),
            color: Colors.red,
            width: 16,
          ),
          BarChartRodData(
            toY: data['Level2']!.toDouble(),
            color: Colors.green,
            width: 16,
          ),
          BarChartRodData(
            toY: data['Level3']!.toDouble(),
            color: Colors.blue,
            width: 16,
          ),
        ],
      ));
    });
    
    
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true),
            ),
               
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return Text('Mon');
                    case 2:
                      return Text('Tue');
                    case 3:
                      return Text('Wed');
                    case 4:
                      return Text('Thu');
                    case 5:
                      return Text('Fri');
                    case 6:
                      return Text('Sat');
                    case 7:
                      return Text('Sun');
                    default:
                      return Text('');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );     
  }

  Widget _circularProgressChart(List<FocusActivity> events) {
    int successCount = events.where((event) => event.isSuccess).length;
    int failureCount = events.length - successCount;
    double successPercentage = (successCount / events.length) * 100;

    return Column(
      children: [
        Text(
          'Success Rate',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Open Sans',
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              Center(
                child: Text(
                  '${successPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans',
                  ),
                ),
              ),
              PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: successCount.toDouble(),
                      color: Colors.green,
                      title: 'Success',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: failureCount.toDouble(),
                      color: Colors.red,
                      title: 'Failure',
                      radius: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

