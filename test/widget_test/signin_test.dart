// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, unused_import, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'signin_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User, FirebaseFirestore, CollectionReference, DocumentReference, DocumentSnapshot])

class SignInWidget extends StatefulWidget {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  SignInWidget({required this.firebaseAuth, required this.firestore});

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
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

  Future<void> signIn() async {
    if (emailController.text.trim().isEmpty) {
      _showErrorDialog('Please enter an email address.');
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      _showErrorDialog('Please enter a password.');
      return;
    }
    showDialog(
      context: context, 
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      });

    try {
      await widget.firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );
      // Simulate navigation and other logic here
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
              onPressed: signIn,
              child: Text('Sign In'),
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
    
    when(mockFirebaseAuth.currentUser).thenReturn(null); // Simulate no user logged in
  });

  testWidgets('Shows error dialog if email is empty', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SignInWidget(
        firebaseAuth: mockFirebaseAuth,
        firestore: mockFirestore,
      ),
    ));

    // Trigger sign in with empty email
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check if error dialog appears
    expect(find.text('Please enter an email address.'), findsOneWidget);
  });

  testWidgets('Shows error dialog if password is empty', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SignInWidget(
        firebaseAuth: mockFirebaseAuth,
        firestore: mockFirestore,
      ),
    ));

    // Set email but leave password empty
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check if error dialog appears
    expect(find.text('Please enter a password.'), findsOneWidget);
  });

  testWidgets('Shows error dialog on FirebaseAuthException', (WidgetTester tester) async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

    await tester.pumpWidget(MaterialApp(
      home: SignInWidget(
        firebaseAuth: mockFirebaseAuth,
        firestore: mockFirestore,
      ),
    ));

    // Set email and password
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Check if error dialog appears
    expect(find.text('No user found for that email.'), findsOneWidget);
  });
}
