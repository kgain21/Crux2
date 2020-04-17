import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/firebase_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FirestoreMock extends Firestore implements Mock {}

void main() {

  FirestoreMock firestoreMock;
  BaseWorkoutRepository firebaseWorkoutRepository;

  var testDate = DateTime(2020); // Jan 1, 2020
  
  setUp(() {
    firestoreMock = FirestoreMock();
    firebaseWorkoutRepository = FirebaseWorkoutRepository(firestore: firestoreMock);
  });

  group('find workout by date tests', () {
    test('given valid date with corresponding workout, should return workout', () {
      
      when(firestoreMock.document(path))
      
      CruxWorkout cruxWorkout = firebaseWorkoutRepository.findWorkoutByDate(testDate);
    });

  });
}