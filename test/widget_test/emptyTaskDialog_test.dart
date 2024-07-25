// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class EmptyTaskNameWidget extends StatefulWidget {
  const EmptyTaskNameWidget({Key? key}) : super(key: key);

  @override
  _TestableWidgetState createState() => _TestableWidgetState();
}

class _TestableWidgetState extends State<EmptyTaskNameWidget> {
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
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Testable Widget')),
      body: Center(
        child: ElevatedButton(
          onPressed: _emptyTaskNameDialog,
          child: Text('Show Dialog'),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Empty Task Name Dialog displays correctly', (WidgetTester tester) async {
    // Build the TestableWidget.
    await tester.pumpWidget(MaterialApp(home: EmptyTaskNameWidget()));

    // Tap the 'Show Dialog' button to trigger the dialog.
    await tester.tap(find.text('Show Dialog'));
    await tester.pump(); // Rebuild the widget tree to display the dialog.

    // Verify the dialog is shown.
    expect(find.byType(AlertDialog), findsOneWidget);

    // Verify the dialog content.
    expect(find.text('Please enter a task name.'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);

    // Close the dialog.
    await tester.tap(find.text('OK'));
    await tester.pump(); // Rebuild the widget tree to close the dialog.
  });
}
