// ignore_for_file: unused_import, depend_on_referenced_packages, unused_local_variable, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/pages/timer_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_firebase.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimerPage Widget Tests', () {
    // Helper function to create a TimerPage widget for testing
    Widget createTimerPage() {
      return MaterialApp(
        home: TimerPage(),
      );
    }

    testWidgets('should start with the timer not running', (WidgetTester tester) async {
      await tester.pumpWidget(createTimerPage());

      final startButton = find.text('START');
      expect(startButton, findsOneWidget);

      final taskNameInput = find.byType(TextField);
      expect(taskNameInput, findsOneWidget);

      final hourPicker = find.text('HH');
      final minutePicker = find.text('MM');
      final secondPicker = find.text('SS');
      expect(hourPicker, findsOneWidget);
      expect(minutePicker, findsOneWidget);
      expect(secondPicker, findsOneWidget);
    });

    testWidgets('should show error dialog when starting timer with zero duration', (WidgetTester tester) async {
      await tester.pumpWidget(createTimerPage());

      final startButton = find.text('START');
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      expect(find.text('Please select a valid time duration.'), findsOneWidget);
    });

    testWidgets('should show error dialog when starting timer with empty task name', (WidgetTester tester) async {
      await tester.pumpWidget(createTimerPage());

      final hoursPicker = find.byKey(Key('hoursPicker')).evaluate().first.widget as CupertinoPicker;
      hoursPicker.onSelectedItemChanged!(1);  // Set hours to 1

      await tester.tap(find.text('START'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a task name.'), findsOneWidget);
    });

    testWidgets('should start timer with valid inputs', (WidgetTester tester) async {
      await tester.pumpWidget(createTimerPage());

      // Set valid task name
      await tester.enterText(find.byType(TextField), 'Test Task');

      // Set hours to 1
      final hoursPicker = find.byKey(Key('hoursPicker')).evaluate().first.widget as CupertinoPicker;
      hoursPicker.onSelectedItemChanged!(1);

      await tester.tap(find.text('START'));
      await tester.pumpAndSettle();

      expect(find.text('START'), findsNothing);
      expect(find.text('Test Task'), findsNothing);
    });
  });
}
