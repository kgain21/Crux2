/*
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crux/backend/repository/workout/model/campus_board_workout.dart';
import 'package:crux/backend/repository/workout/model/climbing_workout.dart';
import 'package:crux/backend/repository/workout/model/core_workout.dart';
import 'package:crux/backend/repository/workout/model/hangboard_workout.dart';
import 'package:crux/backend/repository/workout/model/strength_workout.dart';
import 'package:crux/backend/repository/workout/model/stretching_workout.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crux_workout.g.dart';

@JsonSerializable()
class CruxWorkout extends Object with _$CruxWorkoutSerializerMixin {
  CruxWorkout({
    this.hangboardWorkout,
    this.campusBoardWorkout,
    this.strengthWorkout,
    this.coreWorkout,
    this.stretchingWorkout,
    this.climbingWorkout,
  });

//  factory CruxWorkout([updates(CruxWorkoutBuilder b)]) = _$CruxWorkout;

  factory CruxWorkout.fromJson(Map<String, dynamic> json) => _$CruxWorkoutFromJson(json);

  final HangboardWorkout hangboardWorkout;
  final CampusBoardWorkout campusBoardWorkout;
  final StrengthWorkout strengthWorkout;
  final CoreWorkout coreWorkout;
  final StretchingWorkout stretchingWorkout;
  final ClimbingWorkout climbingWorkout;

*/
/*String toJson() {
    return json.encode(serializers.serializeWith(CruxWorkout.serializer, this));
  }

  static CruxWorkout fromJson(String jsonString) {
    return serializers.deserializeWith(CruxWorkout.serializer, json.decode(jsonString));
  }

  static Serializer<CruxWorkout> get serializer => _$cruxWorkoutSerializer;*/ /*

}
*/
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
