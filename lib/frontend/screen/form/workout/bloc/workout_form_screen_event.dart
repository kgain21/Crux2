part of 'workout_form_screen_bloc.dart';

abstract class WorkoutFormEvent extends Equatable {
  const WorkoutFormEvent();
}

class WorkoutFormInitialized extends WorkoutFormEvent {
  final CruxUser cruxUser;
  final DateTime workoutDate;

  const WorkoutFormInitialized({
    @required this.cruxUser,
    @required this.workoutDate,
  });

  @override
  List<Object> get props => [cruxUser, workoutDate];

  @override
  String toString() => '''WorkoutFormInitialized: { cruxUser: $cruxUser, workoutDate: $workoutDate }''';
}
