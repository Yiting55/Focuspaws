// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'signin_test.mocks.dart';

@GenerateMocks([FirebaseAuth, FirebaseFirestore])

class SignUpWidget extends StatefulWidget {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  SignUpWidget({required this.firebaseAuth, required this.firestore});

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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

  Future<void> signUp() async {
    if (emailController.text.trim().isEmpty) {
        _showErrorDialog('Please enter an email address.');
        return;
    }
    if (passwordController.text.trim().isEmpty) {
      _showErrorDialog('Please enter a password.');
      return;
    }
    try {
      await widget.firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );      
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'invalid-credential':
          errorMessage = 'Please enter a valid email or password.';
          break;
        default:
          errorMessage = e.code;
          break;
      }
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TextField(controller: emailController),
            TextField(controller: passwordController, obscureText: true),
            ElevatedButton(
              onPressed: signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
  });

  testWidgets('Shows error dialog if email is empty during sign up', (WidgetTester tester) async {
    // Initialize the widget wrapped with MaterialApp
    await tester.pumpWidget(MaterialApp(
      home: SignUpWidget(
        firebaseAuth: mockFirebaseAuth,
        firestore: mockFirestore,
      ),
    ));

    // Enter only the password
    await tester.enterText(find.byType(TextField).first, '');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check if error dialog appears with the correct message
    expect(find.text('Please enter an email address.'), findsOneWidget);
  });

  testWidgets('Shows error dialog if password is empty during sign up', (WidgetTester tester) async {
    // Initialize the widget wrapped with MaterialApp
    await tester.pumpWidget(MaterialApp(
      home: SignUpWidget(
        firebaseAuth: mockFirebaseAuth,
        firestore: mockFirestore,
      ),
    ));

    // Enter email but leave the password empty
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), '');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check if error dialog appears with the correct message
    expect(find.text('Please enter a password.'), findsOneWidget);
  });
}
