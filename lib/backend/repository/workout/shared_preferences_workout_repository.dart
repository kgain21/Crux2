import 'dart:developer';

import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/exception/workout_repository_exception.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/serialization/serializers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesWorkoutRepository extends BaseWorkoutRepository {
  static SharedPreferences sharedPreferences;

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
      String workout = sharedPreferences.getString('/users/${cruxUser.uid}/workouts/$dateTime');

      if (null != workout) {
        return Future.value(serializers.deserializeWith(CruxWorkout.serializer, workout));
      }
      return Future.value(null);
    } catch (error) {
      log('Error occurred finding workout for user ${cruxUser.uid} and date $dateTime',
          error: error);
      throw CruxWorkoutRepositoryException();
    }
  }

  /// Updates a workout in the SharedPreferences given a user and workout model.
  /// Returns the workout saved if update was successful; throws error otherwise.
  @override
  Future<CruxWorkout> updateWorkout(CruxUser cruxUser, CruxWorkout cruxWorkout) async {
    try {
      return sharedPreferences
          .setString('/users/${cruxUser.uid}/workouts/${cruxWorkout.workoutDate}',
              serializers.serializeWith(CruxWorkout.serializer, cruxWorkout))
          .then((didSave) {
        if (didSave) {
          return Future.value(cruxWorkout);
        } else {
          log('Failed to update workout for user ${cruxUser.uid} and date ${cruxWorkout.workoutDate}');
          return Future.error(CruxWorkoutRepositoryException());
        }
      });
    } catch (e) {
      log('Error occurred updating workout for user ${cruxUser.uid} and date ${cruxWorkout.workoutDate}',
          error: e);
      return Future.error(CruxWorkoutRepositoryException());
    }
  }
}
