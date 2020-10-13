
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';

abstract class BaseWorkoutRepository {
  CruxWorkout createWorkout(DateTime dateTime);

  Future<CruxWorkout> findWorkoutByDate(DateTime dateTime, CruxUser cruxUser);

  Future<bool> updateWorkoutByDate(DateTime dateTime, CruxWorkout cruxWorkout);

  bool deleteWorkoutByDateTime(DateTime dateTime);
}