import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_event.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_state.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/repository/workout/workout_repository.dart';
import 'package:flutter/cupertino.dart';

class DashboardBloc extends Bloc {
  BaseWorkoutRepository workoutRepository;

  DashboardBloc({@required this.workoutRepository});

  @override
  get initialState => DashboardUninitialized();

  @override
  Stream mapEventToState(event) {
    if (event is CalendarDateChanged) {
      return _mapCalendarDateChangedToState(event);
    }
    return null;
  }

  Stream _mapCalendarDateChangedToState(CalendarDateChanged event) async* {
    yield DashboardDateChangeInProgress();

    var date = event.selectedDate;
    try {
      CruxWorkout cruxWorkout =
          await workoutRepository.findWorkoutByDate(date, event.cruxUser);
      //todo: how do i want to get user here? DI? just pass it in? seems like it should be globally available somehow and I shouldn't have to pass it everywhere
      //todo update: decided to just pass it in the event. If it ends up becoming too clunky I can refactor to a more global approach but for right now this will keep things moving.

      if(null != cruxWorkout) {
        yield DashboardDateChangeSuccess(
            selectedDate: date, cruxWorkout: cruxWorkout);
      } else {
        yield DashboardDateChangeNotFound(selectedDate: date);
        //todo: UI alert and option to create new / copy existing
      }
    } catch (error) {
      log('Failed to retrieve CruxWorkout.', error: error);
      yield DashboardDateChangeError(selectedDate: date);
    }
  }
}
