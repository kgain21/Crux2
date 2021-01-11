part of 'workout_form_screen_bloc.dart';

abstract class WorkoutFormState extends Equatable {
  final CruxUser cruxUser;
  final CruxWorkout cruxWorkout;

  const WorkoutFormState({
    @required this.cruxUser,
    @required this.cruxWorkout,
  });

  @override
  List<Object> get props => [cruxUser, cruxWorkout];
}

class WorkoutFormUninitialized extends WorkoutFormState {
  const WorkoutFormUninitialized() : super(cruxUser: null, cruxWorkout: null);

  @override
  List<Object> get props => [];
}

class WorkoutFormInitializationInProgress extends WorkoutFormState {
  const WorkoutFormInitializationInProgress() : super(cruxUser: null, cruxWorkout: null);

  @override
  List<Object> get props => [];
}

class WorkoutFormInitializationSuccess extends WorkoutFormState {
  const WorkoutFormInitializationSuccess() : super(cruxUser: null, cruxWorkout: null);

  @override
  List<Object> get props => [];
}

class WorkoutFormInitializationFailure extends WorkoutFormState {
  const WorkoutFormInitializationFailure() : super(cruxUser: null, cruxWorkout: null);

  @override
  List<Object> get props => [];
}
