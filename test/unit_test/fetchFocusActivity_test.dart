// ignore_for_file: subtype_of_sealed_class, must_be_immutable, file_names, prefer_const_constructors, unused_import, duplicate_import, prefer_const_declarations, no_leading_underscores_for_local_identifiers, unnecessary_cast, avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'fetchFocusActivity_test.mocks.dart';

// Mock classes
@GenerateMocks([FirebaseAuth, User, FirebaseFirestore, CollectionReference, DocumentReference, DocumentSnapshot])

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockFirebaseFirestore mockFirestore;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockFirestore = MockFirebaseFirestore();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();

    // Mock current user
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test_uid'); // Ensure this is not null

    // Mock Firestore methods
    when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc('test_uid')).thenReturn(mockDocumentReference);
    when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
    when(mockDocumentSnapshot.data()).thenReturn({
      'signupDate': Timestamp.fromDate(DateTime(2023, 7, 26)),
    });
  });

  test('Fetch events and check sign-up date', () async {
    DateTime? signupDate;

    Future<void> _getEvents() async {
      User? currentUser = mockFirebaseAuth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await mockFirestore
            .collection('users')
            .doc(currentUser.uid)
            .get();
        signupDate = (userDoc.data() as Map<String, dynamic>)['signupDate'].toDate();
      }
    }

    // Act
    await _getEvents();

    // Assert
    expect(signupDate, isNotNull);
    expect(signupDate!.year, 2023);
    expect(signupDate!.month, 7);
    expect(signupDate!.day, 26);
  });
}
