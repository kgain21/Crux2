import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:flutter/cupertino.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  BaseWorkoutRepository workoutRepository;

  DashboardBloc({@required this.workoutRepository});

  @override
  get initialState => DashboardUninitialized();

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
    CruxWorkout cruxWorkout =
        await workoutRepository.findWorkoutByDate(date, event.cruxUser).catchError((error) async* {
      log('Failed to retrieve CruxWorkout.', error: error);
      yield DashboardDateChangeError(selectedDate: date);
    });

    if (null != cruxWorkout) {
      yield DashboardDateChangeSuccess(selectedDate: date, cruxWorkout: cruxWorkout);
    } else {
      yield DashboardDateChangeNotFound(selectedDate: date);
    }
  }
}
