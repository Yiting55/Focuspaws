// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/focus_activity.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<FocusActivity>> _events;
  late List<FocusActivity> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _signupDate;
  int _activeDaysCount = 0;

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _getEvents();
  }

  Future<void> _getEvents() async {
    // get events from Firestore 
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      CollectionReference activities = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('allFocusActivity');   

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
      setState(() {
        _signupDate = (userDoc.data() as Map<String, dynamic>)['signupDate'].toDate();
      });

      QuerySnapshot snapshot = await activities.get();
      Map<DateTime, List<FocusActivity>> tempEvents = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        FocusActivity activity = FocusActivity.fromMap(data);
        DateTime date = DateTime(activity.timestamp.year, activity.timestamp.month, activity.timestamp.day);
        if (tempEvents[date] == null) {
          tempEvents[date] = [];
        }
        tempEvents[date]!.add(activity);
      }
      setState(() {
        _events = tempEvents;
        _activeDaysCount = _events.length;
      });
    }
  }

  List<FocusActivity> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents = _getEventsForDay(selectedDay);
    });
    _showFocusDataDialog();
  }

  void _showFocusDataDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Focus Activities'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _selectedEvents.map((event) => ListTile(
              title: Text(event.name),
              subtitle: Text('Duration: ${event.duration} seconds\nStatus: ${event.isSuccess ? 'Success' : 'Failure'}'),
            )).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: Text('OK'),
            )
          ]
        );
      });
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
        appBar: AppBar(
          title: Text('Calendar'),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: _page(),
      ),  
    );
  }

  Widget _page() {
    return Column(
        children: [
          _calendar(),
          const SizedBox(height: 8.0),
          _userInfo(),
        ],
      );
  }

  Widget _calendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: _onDaySelected,
      eventLoader: _getEventsForDay,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 16, 96, 207),
                shape: BoxShape.circle,
              ),
              width: 16.0,
              height: 16.0,
              child: Center(
                child: Text(
                  '${events.length}',
                  style: TextStyle().copyWith(
                    color: Colors.white,
                    fontSize: 12.0,
                  ))
                ),  
              );
          }
          return SizedBox.shrink();
        }
      ),
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: const Color.fromARGB(255, 16, 96, 207),
          shape: BoxShape.circle,
        )
      ),
    );
  }

  // Widget _buildEventsMarker(DateTime date, List events) {
  //   if(events.isNotEmpty) {
  //     return Container(
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: Colors.blue,
  //       ),
  //       width: 16.0,
  //       height: 16.0,
  //       child: Center(
  //         child: Text(
  //           '${events.length}',
  //           style: TextStyle().copyWith(
  //             color: Colors.white,
  //             fontSize: 12.0,
  //           ),
  //         ),)
  //     );
  //   }
  //   return SizedBox.shrink();
  // }

  Widget _userInfo() {
    return Column(
      children: [
        Text(
          _signupDate != null ? 'Sign-up Date: ${_signupDate!.toLocal().toIso8601String().split('T').first}' : 'Sign-up Date: Loading ...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Total Active Days: $_activeDaysCount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold),
        )
      ]
    );
  }
}
