
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';

abstract class BaseWorkoutRepository {
  CruxWorkout createWorkout(DateTime dateTime);

  Future<CruxWorkout> findWorkoutByDate(DateTime dateTime, CruxUser cruxUser);

  CruxWorkout updateWorkoutByDate(DateTime dateTime);

  bool deleteWorkoutByDateTime(DateTime dateTime);

  CruxWorkout save
}