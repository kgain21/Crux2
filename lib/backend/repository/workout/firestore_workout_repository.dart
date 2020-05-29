import 'dart:developer';

import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/exception/workout_repository_exception.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/repository/workout/workout_repository.dart';
import 'package:flutter/widgets.dart';

class FirestoreWorkoutRepository implements BaseWorkoutRepository {
  final Firestore firestore;
  final Serializers serializers;

  FirestoreWorkoutRepository({@required this.firestore, @required this.serializers});

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
  Future<CruxWorkout> findWorkoutByDate(DateTime dateTime, CruxUser user) {
    return firestore
        .collection('/user/${user.email}/workouts') // this and .document just create objects - don't see them throwing errors that need to be caught
        .document(dateTime.toIso8601String())
        .get()
        .then((workout) {
      if (null != workout) {
        return serializers.deserializeWith(CruxWorkout.serializer, workout.data);
      } else {
        return null;
      }
    }, onError: (error) {
      log('Error occurred finding workout for user $user and date $dateTime', error: error);
      throw CruxWorkoutRepositoryException();
    });
  }

  @override
  CruxWorkout updateWorkoutByDate(DateTime dateTime) {
    // TODO: implement updateWorkoutByDate
    throw UnimplementedError();
  }
}
