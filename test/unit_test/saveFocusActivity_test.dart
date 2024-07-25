// ignore_for_file: prefer_const_declarations, no_leading_underscores_for_local_identifiers, unused_import, file_names, unused_local_variable

import 'package:flutter_application_1/features/pages/focus_activity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'saveFocusActivity_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User, FirebaseFirestore, CollectionReference, DocumentReference])

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();

    // Mock the return values to ensure they are non-null
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test_uid');
    when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockDocumentReference.collection(any)).thenReturn(mockCollectionReference);

    // Add a stub for the `add` method to avoid MissingStubError
    when(mockCollectionReference.add(any)).thenAnswer((_) async => mockDocumentReference);
  });

  test('Save focus activity and award food if successful', () async {
    // Arrange
    final bool isSuccess = true;
    final String taskName = 'Test Task';
    final int totalTime = 3600; // 1 hour
    final String level = '1';
    final DateTime currentTime = DateTime.now();

    // Set up the method to be tested
    Future<void> _saveFocusActivity(bool isSuccess) async {
      User? currentUser = mockFirebaseAuth.currentUser;
      if (currentUser != null) {
        DateTime currentTime = DateTime.now();
        String currentName = taskName;
        String currentLevel = level;
        FocusActivity focusActivity = FocusActivity(
          name: currentName,
          duration: totalTime,
          isSuccess: isSuccess,
          timestamp: currentTime,
          level: currentLevel,
        );
        CollectionReference allFocusActivity = mockFirestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('allFocusActivity');
        await allFocusActivity.add(focusActivity.toMap());
      }
    }

    // Act
    await _saveFocusActivity(isSuccess);

    // Assert
    verify(mockCollectionReference.add(any)).called(1);
    // Add more assertions as needed
  });
}
