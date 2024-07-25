// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Define the widget class with passwordConfirmed method
class _SignUpWidgetState {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();

  bool passwordConfirmed() {
    if (passwordController.text.trim() == confirmpasswordController.text.trim()) {
      return true;
    } else {
      // Simulate showing dialog (not tested here, only logic is tested)
      return false;
    }
  }
}

void main() {
  late _SignUpWidgetState signUpWidgetState;

  setUp(() {
    signUpWidgetState = _SignUpWidgetState();
  });

  test('passwordConfirmed returns true when passwords match', () {
    // Arrange
    signUpWidgetState.passwordController.text = 'password123';
    signUpWidgetState.confirmpasswordController.text = 'password123';

    // Act
    bool result = signUpWidgetState.passwordConfirmed();

    // Assert
    expect(result, isTrue);
  });

  test('passwordConfirmed returns false when passwords do not match', () {
    // Arrange
    signUpWidgetState.passwordController.text = 'password123';
    signUpWidgetState.confirmpasswordController.text = 'differentPassword';

    // Act
    bool result = signUpWidgetState.passwordConfirmed();

    // Assert
    expect(result, isFalse);
  });
}
