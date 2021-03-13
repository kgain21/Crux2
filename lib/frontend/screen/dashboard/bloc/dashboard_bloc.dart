import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:flutter/cupertino.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  BaseWorkoutRepository workoutRepository;

  DashboardBloc({@required this.workoutRepository}): super(DashboardUninitialized());

  @override
  Stream<DashboardState> mapEventToState(event) {
    if (event is CalendarDateChanged) {
      return _mapCalendarDateChangedToState(event);
    }
    return null;
  }

  Stream<DashboardState> _mapCalendarDateChangedToState(CalendarDateChanged event) async* {
    yield DashboardDateChangeInProgress();

    var date = event.selectedDate;

    try {
      CruxWorkout cruxWorkout = await workoutRepository
          .findWorkoutByDate(date, event.cruxUser)
          .catchError((error) async* {
        log('Failed to retrieve CruxWorkout.', error: error);
        yield DashboardDateChangeError(selectedDate: date);
      });

      if (null != cruxWorkout) {
        yield DashboardDateChangeSuccess(selectedDate: date, cruxWorkout: cruxWorkout);
      } else {
        var cruxWorkout = CruxWorkout((b) => b..workoutDate = date);
        yield DashboardDateChangeNotFound(selectedDate: date, cruxWorkout: cruxWorkout);
      }

    } catch (error) {
      log('Failed to retrieve CruxWorkout.', error: error);
      yield DashboardDateChangeError(selectedDate: date);
    }
  }
}