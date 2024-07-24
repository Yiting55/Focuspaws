// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'package:test/test.dart';
import 'dart:async';

class TimerController {
  Timer? _timer;
  int _totalTime = 0;
  int _remainingTime = 0;
  bool _isRunning = false;

  bool get isRunning => _isRunning;
  int get remainingTime => _remainingTime;

  void startTimer(int hours, int minutes, int seconds, int minTime) {
    _totalTime = hours * 3600 + minutes * 60 + seconds;
    _remainingTime = _totalTime;

    if (_totalTime < minTime) {
      throw ArgumentError('Time must be at least $minTime seconds');
    }

    _isRunning = true;

    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime -= 1;
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
  }
}

void main() {
  late TimerController timerController;

  setUp(() {
    timerController = TimerController();
  });

  tearDown(() {
    timerController._timer?.cancel();  // Ensure any running timers are canceled after each test
  });

  test('TimerController should start timer and count down correctly', () async {
    // Arrange
    final initialHours = 0;
    final initialMinutes = 0;
    final initialSeconds = 1;
    final minTime = 1;
    
    // Act
    timerController.startTimer(initialHours, initialMinutes, initialSeconds, minTime);

    // Wait for the timer to count down
    await Future.delayed(Duration(seconds: 2));
    await Future.delayed(Duration(milliseconds: 100)); // Delay slightly more than the timer duration

    // Assert
    expect(timerController.remainingTime, 0);
    expect(timerController.isRunning, false);
  });

  test('TimerController should throw ArgumentError for invalid time', () {
    // Arrange
    final initialHours = 0;
    final initialMinutes = 0;
    final initialSeconds = 0;
    final minTime = 1;

    // Act & Assert
    expect(() => timerController.startTimer(initialHours, initialMinutes, initialSeconds, minTime),
        throwsA(isA<ArgumentError>()));
  });
}
