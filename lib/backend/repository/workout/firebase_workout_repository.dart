import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:flutter/widgets.dart';

class FirebaseWorkoutRepository extends BaseWorkoutRepository {
  final Firestore firestore;

  FirebaseWorkoutRepository({@required this.firestore});

  @override
  CruxWorkout createWorkout(DateTime dateTime) {
    // TODO: implement createWorkout
    throw UnimplementedError();
  }

  @override
  bool deleteWorkoutByDateTime(DateTime dateTime) {
    // TODO: implement deleteWorkoutByDateTime
    throw UnimplementedError();
  }

  @override
  CruxWorkout findWorkoutByDate(DateTime dateTime) {
    // TODO: implement findWorkoutByDate
    throw UnimplementedError();
  }

  @override
  CruxWorkout updateWorkoutByDate(DateTime dateTime) {
    // TODO: implement updateWorkoutByDate
    throw UnimplementedError();
  }
}
