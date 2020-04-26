import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class HangboardWorkout {
  final String workoutTitle;
  final List<HangboardExercise> hangboardExerciseEntityList;

  HangboardWorkout(
    this.workoutTitle,
    this.hangboardExerciseEntityList,
  );
}
