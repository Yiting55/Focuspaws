// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_final_fields, override_on_non_overriding_member, unused_element, avoid_print, unused_field, prefer_const_literals_to_create_immutables, collection_methods_unrelated_type, deprecated_member_use

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/features/pages/focus_activity.dart';

class TimerPage extends StatefulWidget{
  final String level;
  final int minTime;
  const TimerPage({super.key, required this.minTime, required this.level});

  @override
  State<TimerPage> createState() => _TimerPageState(); 
}

class _TimerPageState extends State<TimerPage> with WidgetsBindingObserver{  
  bool _isRunning = false;
  Timer? _timer;

  int _selectedHours = 0;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;
  int _remainingTime = 0;
  int _totalTime = 0;

  final TextEditingController _taskNameController = TextEditingController();
  String _taskName = '';

  @override 
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override 
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timer != null) {
      _timer!.cancel();
    }
    _taskNameController.dispose();
    super.dispose();
  }

  @override 
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused) {
      if(_timer != null) {
        _timer?.cancel();
      }
      if(_isRunning) {
        setState(() {
          _stopTimer(false);
        });
      }
    }
  }

  void _startTimer() {
    setState(() {
      _totalTime = _selectedHours * 3600 + _selectedMinutes * 60 + _selectedSeconds;
      _remainingTime = _totalTime;
    });
    // check the time chosen
    if (_totalTime < widget.minTime*60) {
      _invalidTimeDialog();
      return;
    }
    // ensure the task name is not empty
    if (_taskNameController.text.trim().isEmpty) {
      _emptyTaskNameDialog();
      return;
    }
    _taskName = _taskNameController.text.trim();
    // change _isRunning after check
    setState(() {
      _isRunning = true;
    });
    // check whether Timer is null, otherwise cannot apply operation on Timer  
    if (_timer != null) {
      //cancel the running Timer 
      _timer!.cancel();
    }
    // set status to true 
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime = _remainingTime - 1;
        } else {
          _stopTimer(true);
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _totalTime = 0;
      _remainingTime = _totalTime;
    });
  }

  void _stopTimer(bool isSuccess) {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
        _taskNameController.clear();
      });
      _saveFocusActivity(isSuccess);
      if(isSuccess) {
        _congratulationDialog();
      } else {
        _failureDialog();
      }
    }
  }

  void _saveFocusActivity(bool isSuccess) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DateTime currentTime = DateTime.now();
      String currentName = _taskName;
      String currentLevel = widget.level;
      FocusActivity focusActivity = FocusActivity(
        name: currentName, 
        duration: _totalTime, 
        isSuccess: isSuccess,
        timestamp: currentTime,
        level: currentLevel,
      );
      CollectionReference allFocusActivity = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('allFocusActivity');
      await allFocusActivity.add(focusActivity.toMap());
      if (isSuccess) {
        _awardFood(widget.level);
      }
    }
  }

  void _awardFood(String level) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String foodLevel = '$level';
      DateTime expiryDate = DateTime.now().add(Duration(days: 2));
      CollectionReference userFoodCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('foods');
    
      // check if the food item already exists
      QuerySnapshot querySnapshot = await userFoodCollection
        .where('level', isEqualTo: foodLevel)
        .where('expiryDate', isEqualTo: Timestamp.fromDate(expiryDate))
        .limit(1)
        .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        // if the food exists, update the quantity
        DocumentSnapshot doc = querySnapshot.docs.first;
        int currentQuantity = doc['quantity'];
        await doc.reference.update({'quantity': currentQuantity + 1});
      } else {
        // if the food doesn't exist, create a new document
        await userFoodCollection.add({
          'level': foodLevel,
          'quantity': 1,
          'expiryDate': Timestamp.fromDate(expiryDate), 
        });
      }
    }
  }

  void _congratulationDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          title: Text(
            'Congratulations!',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.bold,
              fontSize: 26,
            )),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: 
                Text(
                  'You have successfully focused for the whole task! \nYou have obtained ${widget.level} food!',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 18,
                  )
                ),
            ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer();
              },
              child: Text('OK',
                style: TextStyle(
                  color: Color.fromARGB(255, 137, 57, 10),
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )
              ),
            )
          ],
        );
      }
    );
  }

  void _failureDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          title: Text(
            'Failure!',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.bold,
              fontSize: 26,
            )),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              'You have failed to stay focused.',
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 18,
              )),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer();
              },
              child: Text('OK',
                style: TextStyle(
                  color: Color.fromARGB(255, 137, 57, 10),
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )
              ),
            )
          ],
        );
      }
    );
  }

  void _invalidTimeDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please select a valid time duration.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 18,
                  )),
                SizedBox(height: 10),
                Text(
                  'Min time required: ${widget.minTime} minutes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 16,
                    color: const Color.fromARGB(255, 50, 50, 50),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetTimer();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Color.fromARGB(255, 137, 57, 10),
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                  ),
                ),
              ],
            )
          ],
        );
      }
    );
  }

  void _emptyTaskNameDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please enter a task name.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 18,
                  )),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Color.fromARGB(255, 137, 57, 10),
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                  ),
                ),
              ],
            )
          ],
        );
      });
  }

  double _getProgress() {
    if(_totalTime == 0) {
      return 0;
    }
    return (_totalTime - _remainingTime) / _totalTime;
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
      child: WillPopScope(
        onWillPop: () async {
          if(_timer != null) {
            _timer?.cancel();
          }
          if (_isRunning) {
            setState(() {
              _stopTimer(false);
            });
          }
          return true;
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text('Hunt'),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: _page(),
        ),
      ),  
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: SingleChildScrollView(
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // _progressBar
                _progressBar(),
                SizedBox(height: 40),

                // _taskNameInput
                Visibility(
                  visible: !_isRunning,
                  child: _taskNameInput(),
                ),
                SizedBox(height: 20),

                // _timerSetter
                Visibility(
                  visible: !_isRunning,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _hoursPicker(),
                      _minutesPicker(),
                      _secondsPicker()
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // _counter
                Visibility(
                  visible: _isRunning,
                  child: _counter(),
                ),
                SizedBox(height: 40),

                _startTimerbutton(),
              ],
            ),
        ),
      ),);
  }

  Widget _taskNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: _taskNameController,
        decoration: InputDecoration(
          labelText: 'Enter task name',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _hoursPicker() {
    return Column(
      children: <Widget>[
        Text(
          'HH',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          )),
        SizedBox(
          height: 120,
          width: 100,
          child: CupertinoPicker(
            itemExtent: 30.0,
            onSelectedItemChanged: (index) => setState(() {
              _selectedHours = index;
            }), 
            children: List<Widget>.generate(3, (index) {
              return Center(
                child: Text(
                index.toString(),
                style: TextStyle(
                  fontSize: 20
                ),)
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _minutesPicker() {
    return Column(
      children: <Widget>[
        Text(
          'MM',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          )),
        SizedBox(
          height: 120,
          width: 100,
          child: CupertinoPicker(
            itemExtent: 30.0,
            onSelectedItemChanged: (index) => setState(() {
              _selectedMinutes = index * 10;
            }), 
            children: List<Widget>.generate(7, (index) {
              return Center(
                child: Text(
                (index*10).toString(),
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1.2
                ),)
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _secondsPicker() {
    return Column(
      children: <Widget>[
        Text(
          'SS',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          )),
        SizedBox(
          height: 120,
          width: 100,
          child: CupertinoPicker(
            itemExtent: 30.0,
            onSelectedItemChanged: (index) => setState(() {
              _selectedSeconds = index;
            }), 
            children: List<Widget>.generate(11, (index) {
              return Center(
                child: Text(
                index.toString(),
                style: TextStyle(
                  fontSize: 20,
                ),)
              );
            }),
          ),
        ),
      ],
    );
  }
  
  Widget _progressBar() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: _getProgress()),
      duration: Duration(seconds: 1),
      builder: (context, value, child) {
        return SizedBox(
          height: 250,
          width: 250,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: _getProgress(),
                strokeWidth: 12,
                strokeCap: StrokeCap.round,
                //color: Color.fromARGB(255, 255, 130, 21),
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 130, 21)),
                backgroundColor: Colors.white,
              ),
              Center(
                child: ClipOval(
                  child: Image.asset(
                  'assets/onboarding/logo.png',
                  height: 600,
                  width: 600,
                  fit: BoxFit.cover,
                  ),),
              )
            ]
          ),
        );
      }
    );
  }

  Widget _counter() {
    int totalSeconds = (_remainingTime).toInt();
    int hours = totalSeconds ~/ 3600;
    int minutes = totalSeconds % 3600 ~/ 60;
    int seconds = totalSeconds % 60;
    String counterTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        counterTime,
        style: TextStyle(
        color: Colors.white,
        fontSize: 60,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
        )
      ),
    );
  }

  Widget _startTimerbutton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => {
          if(_isRunning) {
            null,
          } else {
            //_congratulationDialog(),
            _startTimer(),
          }},
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 130, 21),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "START",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ))
        ),
      ),
    );
  }
}