import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class WorkoutFormState extends Equatable {
  final CruxWorkout cruxWorkout;

  const WorkoutFormState({
    @required this.cruxWorkout,
  });

  @override
  List<Object> get props => [cruxWorkout];
}

class WorkoutFormUninitialized extends WorkoutFormState {
  const WorkoutFormUninitialized() : super(cruxWorkout: null);

  @override
  List<Object> get props => [];
}

class WorkoutFormInitializationInProgress extends WorkoutFormState {
  const WorkoutFormInitializationInProgress() : super(cruxWorkout: null);

  @override
  List<Object> get props => [];
}

class WorkoutFormInitializationSuccess extends WorkoutFormState {
  final CruxWorkout cruxWorkout;

  const WorkoutFormInitializationSuccess({@required this.cruxWorkout})
      : super(cruxWorkout: cruxWorkout);

  @override
  List<Object> get props => [cruxWorkout];
}

class WorkoutFormInitializationNotFound extends WorkoutFormState {
  const WorkoutFormInitializationNotFound() : super(cruxWorkout: null);

  @override
  List<Object> get props => [];
}

class WorkoutFormInitializationError extends WorkoutFormState {
  const WorkoutFormInitializationError() : super(cruxWorkout: null);

  @override
  List<Object> get props => [];
}
