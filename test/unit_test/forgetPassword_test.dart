// ignore_for_file: file_names, prefer_const_constructors, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forgetPassword_test.mocks.dart';

Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

@GenerateMocks([FirebaseAuth, User, FirebaseFirestore, CollectionReference, DocumentReference, DocumentSnapshot])

Future<void> passwordReset(BuildContext context, TextEditingController emailController) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Password reset link sent! Check your email.'),
        );
      }
    );
  } on FirebaseAuthException catch (e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
  }
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late TextEditingController emailController;

  setUp(() async {
    await initializeFirebase();
  });
  
  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    emailController = TextEditingController();

    when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
        .thenAnswer((_) async {});
  });

  testWidgets('Shows success dialog when password reset email is sent successfully', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: [
                TextField(controller: emailController),
                ElevatedButton(
                  onPressed: () async {
                    await passwordReset(context, emailController);
                  },
                  child: Text('Reset Password'),
                ),
              ],
            ),
          );
        },
      ),
    ));

    emailController.text = 'test@example.com';
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Password reset link sent! Check your email.'), findsOneWidget);
  });

  testWidgets('Shows error dialog when password reset email fails', (WidgetTester tester) async {
    when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
        .thenThrow(FirebaseAuthException(message: 'Failed to send email', code: ''));

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: [
                TextField(controller: emailController),
                ElevatedButton(
                  onPressed: () async {
                    await passwordReset(context, emailController);
                  },
                  child: Text('Reset Password'),
                ),
              ],
            ),
          );
        },
      ),
    ));

    emailController.text = 'test@example.com';
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Failed to send email'), findsOneWidget);
  });
}
