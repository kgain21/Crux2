import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'climbing_workout.g.dart';

abstract class ClimbingWorkout implements Built<ClimbingWorkout, ClimbingWorkoutBuilder> {
  ClimbingWorkout._();

  factory ClimbingWorkout([updates(ClimbingWorkoutBuilder b)]) = _$ClimbingWorkout;

  static Serializer<ClimbingWorkout> get serializer => _$climbingWorkoutSerializer;
}
