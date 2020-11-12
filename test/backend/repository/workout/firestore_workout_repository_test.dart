import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/workout/exception/workout_repository_exception.dart';
import 'package:crux/backend/repository/workout/firestore_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:mockito/mockito.dart';
import 'package:resource/resource.dart';
import 'package:test/test.dart';

import '../../../test_util/test_model_factory.dart';

class FirestoreMock extends Mock implements Firestore {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class SerializersMock extends Mock implements Serializers {}

Future<void> main() async {
  var firestoreMock;
  var documentReferenceMock;
  var documentSnapshotMock;
  var collectionReferenceMock;
  var serializersMock;

  FirestoreWorkoutRepository firestoreWorkoutRepository;

  var testDate = DateTime(2020, 5, 26, 8, 0, 0).toUtc();
  var testUser = TestModelFactory.getTypicalCruxUser();

  setUp(() {
    firestoreMock = FirestoreMock();
    documentSnapshotMock = DocumentSnapshotMock();
    documentReferenceMock = DocumentReferenceMock();
    collectionReferenceMock = CollectionReferenceMock();
    serializersMock = SerializersMock();

    firestoreWorkoutRepository =
        FirestoreWorkoutRepository(firestore: firestoreMock, serializers: serializersMock);
  });

  group('findWorkoutByDate tests', () {
    test('given valid date with corresponding workout, should return workout', () async {
      when(firestoreMock.collection('/user/${testUser.uid}/workouts'))
          .thenReturn(collectionReferenceMock);

      when(collectionReferenceMock.document('${testDate.toIso8601String()}'))
          .thenReturn(documentReferenceMock);

      when(documentReferenceMock.get())
          .thenAnswer((_) => Future<DocumentSnapshotMock>.value(documentSnapshotMock));

      when(documentSnapshotMock.data).thenReturn({"fake-key": "fake-value"});

      when(serializersMock.deserializeWith(any, any))
          .thenReturn(TestModelFactory.getTypicalCruxWorkout());

      CruxWorkout actualCruxWorkout =
          await firestoreWorkoutRepository.findWorkoutByDate(testDate, testUser);
      assert(null != actualCruxWorkout.campusBoardWorkout);
      assert(null != actualCruxWorkout.coreWorkout);
      assert(null != actualCruxWorkout.strengthWorkout);
      assert(null != actualCruxWorkout.stretchingWorkout);
      assert(null != actualCruxWorkout.climbingWorkout);
      assert(null != actualCruxWorkout.hangboardWorkout);
    });

    test('given no document found, should return null', () async {
      when(firestoreMock.collection('/user/${testUser.uid}/workouts'))
          .thenReturn(collectionReferenceMock);

      when(collectionReferenceMock.document('${testDate.toIso8601String()}'))
          .thenReturn(documentReferenceMock);

      when(documentReferenceMock.get())
          .thenAnswer((_) => Future<DocumentSnapshotMock>.value(documentSnapshotMock));

      when(documentSnapshotMock.data).thenReturn(null);

      CruxWorkout actualCruxWorkout =
          await firestoreWorkoutRepository.findWorkoutByDate(testDate, testUser);
      assert(null == actualCruxWorkout);
    });

    test('given an error occurs on document get, should throw CruxWorkoutRepositoryException',
        () async {
      when(firestoreMock.collection('/user/${testUser.uid}/workouts'))
          .thenReturn(collectionReferenceMock);

      when(collectionReferenceMock.document('${testDate.toIso8601String()}'))
          .thenReturn(documentReferenceMock);

      when(documentReferenceMock.get()).thenAnswer((_) => Future<DocumentSnapshot>.error(Error()));

      await expectLater(() => firestoreWorkoutRepository.findWorkoutByDate(testDate, testUser),
          throwsA(const TypeMatcher<CruxWorkoutRepositoryException>()));
    });

    test('given an error occurs on deserialization, should throw CruxWorkoutRepositoryException',
        () async {
      when(firestoreMock.collection('/user/${testUser.uid}/workouts'))
          .thenReturn(collectionReferenceMock);

      when(collectionReferenceMock.document('${testDate.toIso8601String()}'))
          .thenReturn(documentReferenceMock);

      when(documentReferenceMock.get())
          .thenAnswer((_) => Future<DocumentSnapshot>.value(documentSnapshotMock));

      when(documentSnapshotMock.data).thenReturn(Map<String, dynamic>());

      when(serializersMock.deserializeWith(CruxWorkout.serializer, any)).thenThrow(Error());

      await expectLater(() => firestoreWorkoutRepository.findWorkoutByDate(testDate, testUser),
          throwsA(const TypeMatcher<CruxWorkoutRepositoryException>()));
    });
  });

  group('create workout associated to date tests', () {});

  group('updateWorkoutByDate tests', () {
    test('given valid date with corresponding workout, should update workout and return true',
        () async {
      var workoutResource = const Resource('test/resource/workout/test_workout.json');
      var testWorkout = await workoutResource.readAsString();
      Map<String, dynamic> testWorkoutJson = json.decode(testWorkout);

      CruxWorkout cruxWorkout = TestModelFactory.getTypicalCruxWorkout();

      when(firestoreMock.collection('/user/${testUser.uid}/workouts'))
          .thenReturn(collectionReferenceMock);

      when(collectionReferenceMock.document('$testDate'))
          .thenReturn(documentReferenceMock);

      when(serializersMock.serializeWith(any, cruxWorkout)).thenReturn(testWorkoutJson);

      when(documentReferenceMock.setData(testWorkoutJson))
          .thenAnswer((_) => Future.value(null));

      CruxWorkout updatedWorkout =
          await firestoreWorkoutRepository.updateWorkout(testUser, cruxWorkout);
      assert(null != updatedWorkout);
    });

    test('given valid inputs with exception thrown, should handle exception and return null future',
        () async {
      CruxWorkout cruxWorkout = TestModelFactory.getTypicalCruxWorkout();

      when(firestoreMock.collection('/user/${testUser.uid}/workouts'))
          .thenReturn(collectionReferenceMock);

      when(collectionReferenceMock.document('${testDate.toIso8601String()}'))
          .thenReturn(documentReferenceMock);

      when(serializersMock.serializeWith(any, cruxWorkout)).thenThrow(Exception("Unit Test"));

      await expectLater(() => firestoreWorkoutRepository.updateWorkout(testUser, cruxWorkout),
          throwsA(const TypeMatcher<CruxWorkoutRepositoryException>()));
    });
  });

  group('delete workout tests', () {});

  group('find historic workout by date', () {});
}
