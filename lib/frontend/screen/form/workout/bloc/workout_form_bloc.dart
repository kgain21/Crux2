import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_event.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_state.dart';
import 'package:flutter/widgets.dart';

class WorkoutFormBloc extends Bloc<WorkoutFormEvent, WorkoutFormState> {
  BaseWorkoutRepository workoutRepository;

  WorkoutFormBloc({
    @required this.workoutRepository,
  }) : super(WorkoutFormUninitialized());

  @override
  Stream<WorkoutFormState> mapEventToState(WorkoutFormEvent event) {
    if (event is WorkoutFormInitialized) {
      return _mapWorkoutFormInitializedToState(event);
    } else if (event is WorkoutFormClosed) {
      return _mapWorkoutFormClosedToState(event);
    } else {
      return null;
    }
  }

  Stream<WorkoutFormState> _mapWorkoutFormInitializedToState(WorkoutFormInitialized event) async* {
    yield WorkoutFormInitializationInProgress();

    try {
      var workoutDate = event.workoutDate;
      var cruxWorkout =
          await workoutRepository.findWorkoutByDate(workoutDate, event.cruxUser);

      if (cruxWorkout != null) {
        yield WorkoutFormInitializationSuccess(cruxWorkout: cruxWorkout);
      } else {
        var cruxWorkout = CruxWorkout((b) => b..workoutDate = workoutDate);
        yield WorkoutFormInitializationNotFound(cruxWorkout: cruxWorkout);
      }
    } catch (error) {
      log('Error occurred retrieving cruxWorkout for WorkoutFormScreen.', error: error);
      yield WorkoutFormInitializationError();
    }
  }

  Stream<WorkoutFormState> _mapWorkoutFormClosedToState(WorkoutFormClosed event) async* {
    yield WorkoutFormUninitialized();
  }
}
