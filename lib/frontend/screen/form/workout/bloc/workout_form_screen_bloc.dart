import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'workout_form_screen_event.dart';

part 'workout_form_screen_state.dart';

class WorkoutFormBloc extends Bloc<WorkoutFormEvent, WorkoutFormState> {
  BaseWorkoutRepository workoutRepository;

  WorkoutFormBloc({@required this.workoutRepository})
      : super(WorkoutFormInitializationInProgress());

  @override
  Stream<WorkoutFormState> mapEventToState(WorkoutFormEvent event) {
    if (event is WorkoutFormInitialized) {
      return _mapWorkoutFormInitializedToState(event);
    } else {
      return null;
    }
  }

  Stream<WorkoutFormState> _mapWorkoutFormInitializedToState(WorkoutFormInitialized event) async* {
    workoutRepository.findWorkoutByDate(event.workoutDate, event.cruxUser);
    yield WorkoutFormInitializationSuccess();
  }
}
