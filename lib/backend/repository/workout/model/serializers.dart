import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:crux/backend/repository/workout/model/campus_board_workout.dart';
import 'package:crux/backend/repository/workout/model/climbing_workout.dart';
import 'package:crux/backend/repository/workout/model/core_workout.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/backend/repository/workout/model/hangboard_workout.dart';
import 'package:crux/backend/repository/workout/model/strength_workout.dart';
import 'package:crux/backend/repository/workout/model/stretching_workout.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  CruxWorkout,
  CoreWorkout,
  ClimbingWorkout,
  CampusBoardWorkout,
  HangboardExercise,
  HangboardWorkout,
  StrengthWorkout,
  StretchingWorkout,
])

Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
