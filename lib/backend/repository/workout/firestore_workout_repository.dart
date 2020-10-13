import 'dart:developer';

import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/exception/workout_repository_exception.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
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
    try {
      return firestore
          .collection('/user/${user.uid}/workouts')
          .document(dateTime.toIso8601String())
          .get()
          .then((workout) {
        if (null != workout?.data) {
          return serializers.deserializeWith(CruxWorkout.serializer, workout.data);
        }
        return null;
      }).catchError((error) {
        log(
          'Error occurred deserializing workout for user ${user.uid} and date $dateTime',
          error: error,
        );
        throw CruxWorkoutRepositoryException();
      });
    } catch (error) {
      log('Error occurred finding workout for user ${user.uid} and date $dateTime', error: error);
      throw CruxWorkoutRepositoryException();
    }
  }

  @override
  Future<bool> updateWorkoutByDate(DateTime dateTime, CruxWorkout cruxWorkout) {
    return Future.value(true);
  }
}
