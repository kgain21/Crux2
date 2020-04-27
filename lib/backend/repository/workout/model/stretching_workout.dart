import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stretching_workout.g.dart';

abstract class StretchingWorkout implements Built<StretchingWorkout, StretchingWorkoutBuilder> {
  StretchingWorkout._();

  factory StretchingWorkout([updates(StretchingWorkoutBuilder b)]) = _$StretchingWorkout;

  static Serializer<StretchingWorkout> get serializer => _$stretchingWorkoutSerializer;
}
