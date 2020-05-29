import 'package:built_collection/built_collection.dart';
import 'package:crux/backend/repository/workout/model/campus_board_workout.dart';
import 'package:crux/backend/repository/workout/model/climbing_workout.dart';
import 'package:crux/backend/repository/workout/model/core_workout.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/backend/repository/workout/model/hangboard_workout.dart';
import 'package:crux/backend/repository/workout/model/strength_workout.dart';
import 'package:crux/backend/repository/workout/model/stretching_workout.dart';

class TestModelFactory {

  static CruxWorkout getTypicalCruxWorkout() {
    return CruxWorkout((cw) => cw
      ..hangboardWorkout = (HangboardWorkoutBuilder()
        ..workoutTitle = "Tuesday, May 26, 2020"
        ..hangboardExercises = (ListBuilder<HangboardExercise>([
          HangboardExercise((he) => he
            ..breakDuration = 180
            ..depthMeasurementSystem = "mm"
            ..exerciseTitle = "Repeaters"
            ..fingerConfiguration = "4 Finger"
            ..hangsPerSet = 6
            ..holdDepth = 12
            ..holdType = "Half Crimp"
            ..numberOfHands = 2
            ..numberOfSets = 4
            ..repDuration = 7
            ..resistance = 25
            ..resistanceMeasurementSystem = "lbs"
            ..restDuration = 3
            ..build())
        ])
          ..build())
        ..build())
      ..climbingWorkout = (ClimbingWorkoutBuilder()..build())
      ..stretchingWorkout = (StretchingWorkoutBuilder()..build())
      ..strengthWorkout = (StrengthWorkoutBuilder()..build())
      ..coreWorkout = (CoreWorkoutBuilder()..build())
      ..campusBoardWorkout = (CampusBoardWorkoutBuilder()..build())
      ..build());
  }
}