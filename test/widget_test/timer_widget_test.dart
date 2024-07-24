// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

// Import necessary packages
// Import necessary packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Define the TimerWidget with its state management and functionality
class TimerWidget extends StatefulWidget {
  final int minTime;

  const TimerWidget({super.key, required this.minTime});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _selectedHours;
  late int _selectedMinutes;
  late int _selectedSeconds;
  late TextEditingController _taskNameController;
  late int _totalTime;
  late int _remainingTime;
  bool _isRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _selectedHours = 0;
    _selectedMinutes = 0;
    _selectedSeconds = 0;
    _taskNameController = TextEditingController();
    _totalTime = 0;
    _remainingTime = 0;
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure the timer is canceled when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _totalTime = _selectedHours * 3600 + _selectedMinutes * 60 + _selectedSeconds;
      _remainingTime = _totalTime;
    });

    if (_totalTime < widget.minTime) {
      _invalidTimeDialog();
      return;
    }

    if (_taskNameController.text.trim().isEmpty) {
      _emptyTaskNameDialog();
      return;
    }

    setState(() {
      _isRunning = true;
    });

    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime -= 1;
        } else {
          _stopTimer(true);
        }
      });
    });
  }

  // Public method to start the timer for testing
  void publicStartTimer() => _startTimer();

  void _stopTimer(bool isComplete) {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
    if (isComplete) {
      // Handle completion logic if needed
    }
  }

  void _invalidTimeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invalid Time'),
          content: Text('The selected time is less than the minimum allowed time.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _emptyTaskNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Empty Task Name'),
          content: Text('Please enter a task name.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Hours'),
                    onChanged: (value) => _selectedHours = int.tryParse(value) ?? 0,
                  ),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Minutes'),
                    onChanged: (value) => _selectedMinutes = int.tryParse(value) ?? 0,
                  ),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Seconds'),
                    onChanged: (value) => _selectedSeconds = int.tryParse(value) ?? 0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: publicStartTimer,
              child: Text(_isRunning ? 'Stop Timer' : 'Start Timer'),
            ),
            if (_isRunning)
              Text('Remaining Time: ${_remainingTime}s'),
          ],
        ),
      ),
    );
  }
}

// Test cases for TimerWidget
void main() {
  testWidgets('TimerWidget _startTimer method', (WidgetTester tester) async {
    // Build the TimerWidget
    await tester.pumpWidget(MaterialApp(
      home: TimerWidget(minTime: 5), // Set minTime to 5 seconds
    ));

    // Enter data into text fields
    await tester.enterText(find.byType(TextField).at(0), 'Test Task'); // Task Name
    await tester.enterText(find.byType(TextField).at(1), '0'); // Hours
    await tester.enterText(find.byType(TextField).at(2), '0'); // Minutes
    await tester.enterText(find.byType(TextField).at(3), '10'); // Seconds

    // Trigger the startTimer method
    await tester.tap(find.text('Start Timer'));
    await tester.pump(); // Rebuild the widget

    // Verify that the timer starts
    expect(find.text('Start Timer'), findsNothing);
    expect(find.textContaining('Remaining Time: '), findsOneWidget);

    // Wait for 10 seconds to ensure the timer has run
    await tester.pump(Duration(seconds: 10));

    // Verify the remaining time
    expect(find.text('Remaining Time: 0s'), findsOneWidget);
  });

  testWidgets('Shows invalid time dialog if time is less than minimum', (WidgetTester tester) async {
    // Build the TimerWidget
    await tester.pumpWidget(MaterialApp(
      home: TimerWidget(minTime: 10), // Set minTime to 10 seconds
    ));

    // Enter data into text fields
    await tester.enterText(find.byType(TextField).at(0), 'Test Task'); // Task Name
    await tester.enterText(find.byType(TextField).at(1), '0'); // Hours
    await tester.enterText(find.byType(TextField).at(2), '0'); // Minutes
    await tester.enterText(find.byType(TextField).at(3), '5'); // Seconds

    // Trigger the startTimer method
    await tester.tap(find.text('Start Timer'));
    await tester.pump(); // Rebuild the widget

    // Verify the invalid time dialog is shown
    expect(find.text('Invalid Time'), findsOneWidget);
  });

  testWidgets('Shows empty task name dialog if task name is empty', (WidgetTester tester) async {
    // Build the TimerWidget
    await tester.pumpWidget(MaterialApp(
      home: TimerWidget(minTime: 5), // Set minTime to 5 seconds
    ));

    // Enter data into text fields
    await tester.enterText(find.byType(TextField).at(1), '0'); // Hours
    await tester.enterText(find.byType(TextField).at(2), '0'); // Minutes
    await tester.enterText(find.byType(TextField).at(3), '10'); // Seconds

    // Trigger the startTimer method
    await tester.tap(find.text('Start Timer'));
    await tester.pump(); // Rebuild the widget

    // Verify the empty task name dialog is shown
    expect(find.text('Empty Task Name'), findsOneWidget);
    
    // Ensure widget is properly cleaned up
    await tester.pumpWidget(Container()); // Dispose the widget
    await tester.pump(); // Ensure pending timers are processed
  });
}
