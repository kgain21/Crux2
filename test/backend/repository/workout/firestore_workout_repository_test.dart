import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/firestore_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/serialization/serializers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resource/resource.dart';

class FirestoreMock extends Mock implements Firestore {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

Future<void> main() async {
  var firestoreMock;
  var documentReferenceMock;
  var documentSnapshotMock;
  var collectionReferenceMock;

  FirestoreWorkoutRepository firestoreWorkoutRepository;

  var workoutResource = const Resource('test/resource/workout/test_workout.json');
  var testWorkout = await workoutResource.readAsString();
  Map<String, dynamic> testWorkoutJson = json.decode(testWorkout);

  var testDate = DateTime(2020); // Jan 1, 2020
  var testUser = CruxUser(displayName: 'Kyle Gain', email: 'abc123@gmail.com');

  setUp(() {
    firestoreMock = FirestoreMock();
    documentSnapshotMock = DocumentSnapshotMock();
    documentReferenceMock = DocumentReferenceMock();
    collectionReferenceMock = CollectionReferenceMock();
    firestoreWorkoutRepository =
        FirestoreWorkoutRepository(firestore: firestoreMock, serializers: serializers);
  });

  group('find workout by date tests', () {
    test('given valid date with corresponding workout, should return workout', () async {
      when(firestoreMock.collection('/user/${testUser.email}/workouts'))
          .thenReturn(collectionReferenceMock);

      when(collectionReferenceMock.document('${testDate.toIso8601String()}'))
          .thenReturn(documentReferenceMock);

      when(documentReferenceMock.get()).thenAnswer((_) => Future<DocumentSnapshotMock>.value(documentSnapshotMock));

      when(documentSnapshotMock.data).thenReturn(testWorkoutJson);

      CruxWorkout actualCruxWorkout = await firestoreWorkoutRepository.findWorkoutByDate(testDate, testUser);
      assert(null != actualCruxWorkout.campusBoardWorkout);
      assert(null != actualCruxWorkout.coreWorkout);
      assert(null != actualCruxWorkout.strengthWorkout);
      assert(null != actualCruxWorkout.stretchingWorkout);
      assert(null != actualCruxWorkout.climbingWorkout);
      assert(null != actualCruxWorkout.hangboardWorkout);
    });
  });

  group('create workout associated to date tests', () {});

  group('update workout tests', () {});

  group('delete workout tests', () {});

  group('find historic workout by date', () {});
}
