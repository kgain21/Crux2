import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crux/backend/repository/workout/model/campus_board_workout.dart';
import 'package:crux/backend/repository/workout/model/climbing_workout.dart';
import 'package:crux/backend/repository/workout/model/core_workout.dart';
import 'package:crux/backend/repository/workout/model/hangboard_workout.dart';
import 'package:crux/backend/repository/workout/model/strength_workout.dart';
import 'package:crux/backend/repository/workout/model/stretching_workout.dart';

part 'crux_workout.g.dart';

abstract class CruxWorkout implements Built<CruxWorkout, CruxWorkoutBuilder> {
  CruxWorkout._();

  factory CruxWorkout([updates(CruxWorkoutBuilder b)]) = _$CruxWorkout;

  static Serializer<CruxWorkout> get serializer => _$cruxWorkoutSerializer;

  @nullable
  HangboardWorkout get hangboardWorkout;

  @nullable
  CampusBoardWorkout get campusBoardWorkout;

  @nullable
  StrengthWorkout get strengthWorkout;

  @nullable
  CoreWorkout get coreWorkout;

  @nullable
  StretchingWorkout get stretchingWorkout;

  @nullable
  ClimbingWorkout get climbingWorkout;
}
