// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestPickerWidgets extends StatefulWidget {
  @override
  _TestPickerWidgetsState createState() => _TestPickerWidgetsState();
}

class _TestPickerWidgetsState extends State<TestPickerWidgets> {
  int _selectedHours = 0;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            _hoursPicker(),
            _minutesPicker(),
            _secondsPicker(),
            _counter(),
          ],
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
          ),
        ),
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
                  key: Key('hours_$index'), // Assign a key for each item
                  style: TextStyle(fontSize: 20),
                ),
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
          ),
        ),
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
                  (index * 10).toString(),
                  key: Key('minutes_$index'), // Assign a key for each item
                  style: TextStyle(fontSize: 20, letterSpacing: 1.2),
                ),
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
          ),
        ),
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
                  key: Key('seconds_$index'), // Assign a key for each item
                  style: TextStyle(fontSize: 20),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _counter() {
    int hours = _selectedHours;
    int minutes = _selectedMinutes;
    int seconds = _selectedSeconds;
    String counterTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        counterTime,
        key: Key('counter'), // Assign a key for the counter
        style: TextStyle(
          color: Colors.black,
          fontSize: 60,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

void main() {
  testWidgets('All pickers and counter widgets work correctly', (WidgetTester tester) async {
    // Build the TestPickerWidgets.
    await tester.pumpWidget(TestPickerWidgets());

    // Verify if the widgets are displayed
    expect(find.text('HH'), findsOneWidget);
    expect(find.text('MM'), findsOneWidget);
    expect(find.text('SS'), findsOneWidget);

    // Verify initial values in pickers
    expect(find.text('0'), findsNWidgets(3)); // Initial 0 in hours, minutes, seconds pickers

    // Interact with the _hoursPicker
    await tester.drag(find.byKey(Key('hours_0')), Offset(0, -30));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('hours_1')), findsOneWidget);

    // Interact with the _minutesPicker
    await tester.drag(find.byKey(Key('minutes_0')), Offset(0, -30 * 2));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('minutes_2')), findsOneWidget); // 20 minutes

    // Interact with the _secondsPicker
    await tester.drag(find.byKey(Key('seconds_0')), Offset(0, -30 * 3));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('seconds_3')), findsOneWidget);

    // Check the counter display
    expect(find.byKey(Key('counter')), findsOneWidget);
    expect(find.text('01:20:03'), findsOneWidget); // Test counter format for given value
  });
}
