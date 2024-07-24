import 'package:flutter_test/flutter_test.dart';

class TimerController {
  int _totalTime = 0;
  int _remainingTime = 0;

  void _resetTimer() {
    _totalTime = 0;
    _remainingTime = _totalTime;
  }

  // For testing purposes, we expose these properties
  int get totalTime => _totalTime;
  int get remainingTime => _remainingTime;
}

void main() {
  late TimerController timerController;

  setUp(() {
    timerController = TimerController();
  });

  test('TimerController should reset timer values to 0', () {
    // Arrange
    // Manually set non-zero values to simulate a running timer state
    timerController._totalTime = 120; // Example value: 2 minutes
    timerController._remainingTime = 120; // Example value: 2 minutes

    // Act
    timerController._resetTimer();

    // Assert
    expect(timerController.totalTime, 0);
    expect(timerController.remainingTime, 0);
  });
}
