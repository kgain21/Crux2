import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'core_workout.g.dart';

abstract class CoreWorkout implements Built<CoreWorkout, CoreWorkoutBuilder> {
  CoreWorkout._();

  factory CoreWorkout([updates(CoreWorkoutBuilder b)]) = _$CoreWorkout;

  static Serializer<CoreWorkout> get serializer => _$coreWorkoutSerializer;
}
