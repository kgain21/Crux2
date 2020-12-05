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

  /// Finds a workout given a date and user.
  /// Returns the workout if found; null otherwise.
  /// Throws an exception on deserialization error or database connection error for UI handling.
  @override
  Future<CruxWorkout> findWorkoutByDate(DateTime dateTime, CruxUser cruxUser) {
    try {
      return firestore
          .collection('/user/${cruxUser.uid}/workouts')
          .document(dateTime.toIso8601String())
          .get()
          .then((workout) {
        if (null != workout?.data) {
          return Future.value(serializers.deserializeWith(CruxWorkout.serializer, workout.data));
        }
        return Future.value(null);
      }).catchError((error) {
        log(
          'Error occurred deserializing workout for user ${cruxUser.uid} and date $dateTime',
          error: error,
        );
        throw CruxWorkoutRepositoryException();
      });
    } catch (error) {
      log('Error occurred finding workout for user ${cruxUser.uid} and date $dateTime',
          error: error);
      throw CruxWorkoutRepositoryException();
    }
  }

  /// Updates a workout in Firestore given a user and workout model.
  /// Returns the workout saved if update was successful; throws error otherwise.
  @override
  Future<CruxWorkout> updateWorkout(CruxUser cruxUser, CruxWorkout cruxWorkout) async {
    try {
      return firestore
          .collection('/user/${cruxUser.uid}/workouts')
          .document('${cruxWorkout.workoutDate.toUtc()}')
          .setData(serializers.serializeWith(CruxWorkout.serializer, cruxWorkout))
          .then((_) => Future.value(cruxWorkout));
    } catch (e) {
      log('Error occurred updating workout for user ${cruxUser.uid} and date ${cruxWorkout.workoutDate}',
          error: e);
      return Future.error(CruxWorkoutRepositoryException());
    }
  }
}
