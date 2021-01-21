
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';

abstract class BaseWorkoutRepository {
  CruxWorkout createWorkout(CruxUser cruxUser, DateTime dateTime);

  Future<CruxWorkout> findWorkoutByDate(DateTime dateTime, CruxUser cruxUser);

  Future<CruxWorkout> updateWorkout(CruxUser cruxUser, CruxWorkout cruxWorkout);

  bool deleteWorkoutByDateTime(DateTime dateTime);
}