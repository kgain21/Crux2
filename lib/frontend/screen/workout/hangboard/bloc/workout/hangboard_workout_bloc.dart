import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/workout/hangboard_workout_event.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/workout/hangboard_workout_state.dart';

class HangboardWorkoutBloc
    extends Bloc<HangboardWorkoutEvent, HangboardWorkoutState> {
//  final HangboardWorkoutsRepository hangboardWorkoutsRepository;
//  HangboardWorkout _hangboardWorkout;

  HangboardWorkoutBloc(): super(HangboardWorkoutLoadInProgress());

  @override
  Stream<HangboardWorkoutState> mapEventToState(
      HangboardWorkoutEvent event) async* {
    if (event is HangboardWorkoutLoaded) {
      yield* _mapHangboardWorkoutLoadedToState(event);
    } else if (event is HangboardWorkoutAdded) {
      yield* _mapAddWorkoutToState(event);
    } else if (event is HangboardWorkoutDeleted) {
      yield* _mapDeleteWorkoutToState(event);
    } else if (event is HangboardWorkoutReloaded) {
      yield* _mapHangboardWorkoutReloadedToState(event);
    } else if (event is HangboardWorkoutExerciseDeleted) {
      yield* _mapHangboardWorkoutExerciseDeletedToState(event);
    } else if (event is ExerciseTileLongPressed) {
      yield* _mapExerciseTileLongPressedToState(event);
    } else if (event is ExerciseTileTapped) {
      yield* _mapExerciseTileTappedToState(event);
    }
  }

  Stream<HangboardWorkoutState> _mapHangboardWorkoutLoadedToState(
      HangboardWorkoutLoaded event) async* {
    try {
//      _hangboardWorkout = HangboardWorkout.fromEntity(
//          await hangboardWorkoutsRepository
//              .getWorkoutByWorkoutTitle(event.workoutTitle));

      yield HangboardWorkoutLoadSuccess(hangboardWorkout: event.hangboardWorkout);
    } catch (_) {
      yield HangboardWorkoutLoadFailure();
    }
  }

  Stream<HangboardWorkoutState> _mapAddWorkoutToState(event) {
    return null;
  }

  Stream<HangboardWorkoutState> _mapDeleteWorkoutToState(event) {
    return null;
  }

  Stream<HangboardWorkoutState> _mapHangboardWorkoutReloadedToState(
      HangboardWorkoutReloaded event) async* {
//    _hangboardWorkout = event.hangboardWorkout;
    yield HangboardWorkoutLoadSuccess(hangboardWorkout: event.hangboardWorkout);
  }

  //todo: looks like it's just triggering off the repo listener so we don't
  //todo: need to yield a state here? not sure if I like that or not
  Stream<HangboardWorkoutState> _mapHangboardWorkoutExerciseDeletedToState(
      HangboardWorkoutExerciseDeleted event) async* {
    //todo:2/13/21 - come back to deleting later (if I even want it - might just cut it to reduce complexity here)
//    var updatedHangboardWorkout = await hangboardWorkoutsRepository
//        .deleteExerciseFromWorkout(
//            _hangboardWorkout.workoutTitle, event.hangboardExercise)
//        .then((hangboardWorkout) {
//      if (hangboardWorkout == null) {
//        return _hangboardWorkout;
//      } else {
//        _hangboardWorkout = hangboardWorkout;
//        return hangboardWorkout;
//      }
//    }).catchError((error) {
//      return _hangboardWorkout;
//    });

//    yield HangboardWorkoutLoaded(updatedHangboardWorkout);
  }

  Stream<HangboardWorkoutState> _mapExerciseTileLongPressedToState(
      ExerciseTileLongPressed event) async* {
    yield HangboardWorkoutEditInProgress(event.hangboardWorkout);
  }

  Stream<HangboardWorkoutState> _mapExerciseTileTappedToState(
      ExerciseTileTapped event) async* {
    yield HangboardWorkoutLoadSuccess(hangboardWorkout: event.hangboardWorkout);
  }
}
