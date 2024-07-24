// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/focus_activity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SummaryPage extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const SummaryPage({super.key, required this.startDate, required this.endDate});

  Map<String, Map<String, int>> _getWeeklyData(List<FocusActivity> events) {
    Map<String, Map<String, int>> weeklyData = {
      '1': {'Level 1': 0, 'Level 2': 0, 'Level 3': 0}, // Monday
      '2': {'Level 1': 0, 'Level 2': 0, 'Level 3': 0}, // Tuesday
      '3': {'Level 1': 0, 'Level 2': 0, 'Level 3': 0}, // Wednesday
      '4': {'Level 1': 0, 'Level 2': 0, 'Level 3': 0}, // Thursday
      '5': {'Level 1': 0, 'Level 2': 0, 'Level 3': 0}, // Friday
      '6': {'Level 1': 0, 'Level 2': 0, 'Level 3': 0}, // Saturday
      '7': {'Level 1': 0, 'Level 2': 0, 'Level 3': 0}, // Sunday
    };

    for (var event in events) {
      if (event.isSuccess) {
        String day = event.timestamp.weekday.toString();
        switch (event.level) {
          case 'Level 1': 
            weeklyData[day]!['Level 1'] = (weeklyData[day]!['Level 1'] ?? 0) + event.duration;
            break;
          case 'Level 2': 
            weeklyData[day]!['Level 2'] = (weeklyData[day]!['Level 2'] ?? 0) + event.duration;
            break;
          case 'Level 3': 
            weeklyData[day]!['Level 3'] = (weeklyData[day]!['Level 3'] ?? 0) + event.duration;
            break;
        }
      }
    }
    return weeklyData;
  }

  List<FocusActivity> _filterCurrentWeekActivities(List<FocusActivity> events) {
    DateTime startOfWeek = startDate;
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    return events.where((event) {
      return event.timestamp.isAfter(startOfWeek) && event.timestamp.isBefore(endOfWeek);
    }).toList();
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

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  double _calculateAverageFocusTime(List<FocusActivity> events) {
    List<FocusActivity> successfulEvents = events.where((event) => event.isSuccess).toList();
    if (successfulEvents.isEmpty) return 0;
    double totalFocusTimeinSeconds = successfulEvents.fold(0, (totalTime, event) => totalTime + event.duration);
    double totalFocusTime = totalFocusTimeinSeconds / 60.0;

    // Calculate active days
    Set<int> activeDays = successfulEvents.map((e) => e.timestamp.weekday).toSet();
    int activeDaysCount = activeDays.length;

    return activeDaysCount > 0 ? totalFocusTime / activeDaysCount : 0; // Average per active day
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
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text('Weekly Summary'),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0, // Remove elevation
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.0),
            child: Text(
              '${startDate.day} ${_getMonthName(startDate.month)} - ${endDate.day} ${_getMonthName(endDate.month)}',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
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
          List<FocusActivity> events = _filterCurrentWeekActivities(snapshot.data!);
          double averageFocusTime = _calculateAverageFocusTime(events);
          int totalAttempts = events.length;
          int successfulTasks = events.where((event) => event.isSuccess).length;
          int failureTasks = totalAttempts - successfulTasks;
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // focus time summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        _averageFocusTime(averageFocusTime),
                        const SizedBox(height: 32),
                        _stackedBarChart(events),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  //successful task summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        _taskNumberSummary(totalAttempts, successfulTasks, failureTasks),
                        const SizedBox(height: 10),
                        _circularProgressChart(events),
                      ],
                    ),
                  ), 
                ],
              ),
            ),
          );
        }
      },
    );
  }

  RichText _averageFocusTime(double averageFocusTime) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Average\n',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Open Sans',
              color: Colors.black),
          ),
          TextSpan(
            text: '${averageFocusTime.toStringAsFixed(1)} minutes /day',
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
              color: Colors.black),
          ),
        ]
      ),
    );
  }

  Widget _stackedBarChart(List<FocusActivity> events) {

    Map<String, Map<String, int>> weeklyData = _getWeeklyData(events);
    List<BarChartGroupData> barGroups = [];

    double maxMins = 0.0;
    List<String> orderedDays = ['7', '1', '2', '3', '4', '5', '6'];

    for (var day in orderedDays) {
      double level1Minutes = weeklyData[day]!['Level 1']!.toDouble() / 60.0;
      double level2Minutes = weeklyData[day]!['Level 2']!.toDouble() / 60.0;
      double level3Minutes = weeklyData[day]!['Level 3']!.toDouble() / 60.0;
      double totalFocusMinutes = level1Minutes + level2Minutes + level3Minutes;
      // double remainingHours = maxMins - totalFocusHours;
      if (totalFocusMinutes > maxMins) {
        maxMins = totalFocusMinutes;
      }
      maxMins = ((maxMins / 2).ceil()) * 2;      

      barGroups.add(BarChartGroupData(
        x: int.parse(day),
        barRods: [
          BarChartRodData(
            borderRadius: BorderRadius.circular(16),
            toY: maxMins,
            color: const Color.fromARGB(96, 186, 186, 186),
            width: 16,
            rodStackItems: [
              BarChartRodStackItem(0, level3Minutes, Color.fromARGB(255, 18, 68, 109)),
              BarChartRodStackItem(level3Minutes, level3Minutes + level2Minutes, Color.fromARGB(255, 22, 103, 169)),
              BarChartRodStackItem(level3Minutes + level2Minutes, totalFocusMinutes, Colors.lightBlue),
              // BarChartRodStackItem(totalFocusHours, maxMins, Colors.white),
            ],
        ),],
      ));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: maxMins,
              minY: 0,
              
              barGroups: barGroups,
              titlesData: FlTitlesData(
                // dont show leftTitles and topTitles
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, 
                    reservedSize: 30,
                    //interval: 2,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() % 2 == 0) {
                        return Text("${value.toInt()}'");
                      } else {
                        return Text('');
                      }
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
                   
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 7:
                          return Text('S');
                        case 1:
                          return Text('M');
                        case 2:
                          return Text('T');
                        case 3:
                          return Text('W');
                        case 4:
                          return Text('T');
                        case 5:
                          return Text('F');
                        case 6:
                          return Text('S');
                        default:
                          return Text('');
                      }
                    },
                  ),
                ),
              ),
              gridData: FlGridData(show: false), 
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  // tooltipBgColor: Colors.grey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String day = orderedDays[group.x.toInt()];
                    double level1Minutes = weeklyData[day]!['Level 1']!.toDouble() / 60.0;
                    double level2Minutes = weeklyData[day]!['Level 2']!.toDouble() / 60.0;
                    double level3Minutes = weeklyData[day]!['Level 3']!.toDouble() / 60.0;
                    return BarTooltipItem(
                      'Level 1: ${level1Minutes.toStringAsFixed(2)} Min\n'
                      'Level 2: ${level2Minutes.toStringAsFixed(2)} Min\n'
                      'Level 3: ${level3Minutes.toStringAsFixed(2)} Min',
                      TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(Colors.lightBlue, 'Level 1'),
            const SizedBox(width: 20),
            _legendItem(Color.fromARGB(255, 22, 103, 169), 'Level 2'),
            const SizedBox(width: 20),
            _legendItem(Color.fromARGB(255, 18, 68, 109), 'Level 3'),
          ],
        )
      ],
    );     
  }
  
  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _circularProgressChart(List<FocusActivity> events) {
    int successCount = events.where((event) => event.isSuccess).length;
    int totalCount = events.length;

    return SizedBox(
      height: 250,
      child: Center(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 200.0,
              width: 200.0,
              child: CircularProgressIndicator(
                strokeWidth: 12, // Adjust thickness of the circle
                value: totalCount != 0 ? successCount / totalCount : 0,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Success',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      '${(successCount / totalCount * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskNumberSummary(int totalAttempts, int successfulTasks, int failureTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Total\n',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Open Sans',
                  color: Colors.black),
              ),
              TextSpan(
                text: '${totalAttempts.toString()} tasks',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Open Sans',
                  color: Colors.black),
              ),
            ]
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _summaryTextItem('Successful', successfulTasks.toString()),
            SizedBox(width: 150),
            _summaryTextItem('Failed', failureTasks.toString()),
          ],
        ),
      ],
    );
  }

  Widget _summaryTextItem(String label, String value) {
  return Column(
    children: [
      Text(label, style: TextStyle(fontSize: 15)),
      SizedBox(height: 5),
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ],
  );
}
}

