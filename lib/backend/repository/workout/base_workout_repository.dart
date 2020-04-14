
import 'package:crux/backend/repository/workout/model/crux_workout.dart';

abstract class BaseWorkoutRepository {
  CruxWorkout createWorkout(DateTime dateTime);

  CruxWorkout findWorkoutByDate(DateTime dateTime);

  CruxWorkout updateWorkoutByDate(DateTime dateTime);

  bool deleteWorkoutByDateTime(DateTime dateTime);
}