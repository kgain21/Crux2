import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'strength_workout.g.dart';

abstract class StrengthWorkout implements Built<StrengthWorkout, StrengthWorkoutBuilder> {
  StrengthWorkout._();

  factory StrengthWorkout([updates(StrengthWorkoutBuilder b)]) = _$StrengthWorkout;

  static Serializer<StrengthWorkout> get serializer => _$strengthWorkoutSerializer;
}
