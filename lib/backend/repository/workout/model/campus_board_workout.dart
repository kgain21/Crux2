import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crux/backend/repository/workout/model/campus_board_exercise.dart';

part 'campus_board_workout.g.dart';

abstract class CampusBoardWorkout implements Built<CampusBoardWorkout, CampusBoardWorkoutBuilder> {
  CampusBoardWorkout._();

  factory CampusBoardWorkout([updates(CampusBoardWorkoutBuilder b)]) = _$CampusBoardWorkout;

  static Serializer<CampusBoardWorkout> get serializer => _$campusBoardWorkoutSerializer;

  @nullable
  BuiltList<CampusBoardExercise> get campusBoardExercises;
}
