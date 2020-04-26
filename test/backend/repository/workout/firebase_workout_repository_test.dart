import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/firebase_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resource/resource.dart';

class FirestoreMock extends Mock implements Firestore {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot{}

class CollectionReferenceMock extends Mock implements CollectionReference {}

Future<void> main() async {
  FirestoreMock firestoreMock;
  DocumentReferenceMock documentReferenceMock;
  DocumentSnapshotMock documentSnapshotMock;
  CollectionReferenceMock collectionReferenceMock;
  BaseWorkoutRepository firebaseWorkoutRepository;

  var workoutResource = const Resource('package:resource/workout/test_workout.json');
  var testWorkout = await workoutResource.readAsString();
  var testWorkoutJson = json.decode(testWorkout);

  var testDate = DateTime(2020); // Jan 1, 2020
  var currentUser = 'Kyle Gain';

  setUp(() {
    firestoreMock = FirestoreMock();
    documentSnapshotMock = DocumentSnapshotMock();
    documentReferenceMock = DocumentReferenceMock();
    collectionReferenceMock = CollectionReferenceMock();
    firebaseWorkoutRepository = FirebaseWorkoutRepository(firestore: firestoreMock);
  });

  group('find workout by date tests', () {
    test('given valid date with corresponding workout, should return workout', () {
      when(firestoreMock.collection('user/$currentUser/workouts/'))
          .thenReturn(collectionReferenceMock);

      when(firestoreMock.document('${testDate.toIso8601String()}'))
          .thenReturn(documentReferenceMock);

      when(documentReferenceMock.get()).thenAnswer((_) => Future.value(documentSnapshotMock));

      when(documentSnapshotMock.data).thenReturn(testWorkoutJson);
      CruxWorkout cruxWorkout = firebaseWorkoutRepository.findWorkoutByDate(testDate);
    });
  });

  group('create workout associated to date tests', () {

  });

  group('update workout tests', () {

  });

  group('delete workout tests', () {

  });

  group('find historic workout by date', () {

  });
}
