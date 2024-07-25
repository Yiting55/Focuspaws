// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Progress bar renders correctly and updates progress', (WidgetTester tester) async {
    // Create a dummy parent widget to hold the _progressBar widget
    double progress = 0.5;
    
    Widget createProgressBar() {
      return MaterialApp(
        home: Scaffold(
          body: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress),
            duration: Duration(seconds: 1),
            builder: (context, value, child) {
              return SizedBox(
                height: 250,
                width: 250,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
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
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(createProgressBar());

    // Verify if the CircularProgressIndicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify if the progress value is initially set correctly
    CircularProgressIndicator progressBar = tester.widget(find.byType(CircularProgressIndicator));
    expect(progressBar.value, equals(0.5));

    // Verify if the image is displayed
    expect(find.byType(Image), findsOneWidget);

    // Change the progress value and pump the widget to trigger the animation
    progress = 1.0;
    await tester.pumpWidget(createProgressBar());
    await tester.pump(Duration(seconds: 1));

    // Verify if the CircularProgressIndicator updated the progress value
    progressBar = tester.widget(find.byType(CircularProgressIndicator));
    expect(progressBar.value, equals(1.0));
  });
}
