import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';

part 'hangboard_workout.g.dart';

abstract class HangboardWorkout implements Built<HangboardWorkout, HangboardWorkoutBuilder> {
  HangboardWorkout._();

  factory HangboardWorkout([updates(HangboardWorkoutBuilder b)]) = _$HangboardWorkout;

  static Serializer<HangboardWorkout> get serializer => _$hangboardWorkoutSerializer;

  String get workoutTitle;

  BuiltList<HangboardExercise> get hangboardExercises;
}
