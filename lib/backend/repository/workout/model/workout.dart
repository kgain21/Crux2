import 'exercise.dart';

abstract class Workout {

  final String workoutTitle;
  final List<Exercise> exerciseList;

  Workout(this.workoutTitle, this.exerciseList);

}
