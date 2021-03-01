import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/timer/timer_type_enum.dart';
import 'package:crux/frontend/screen/workout/timer/bloc/timer_event.dart';

import 'hangboard_exercise_event.dart';
import 'hangboard_exercise_state.dart';

class HangboardExerciseBloc extends Bloc<HangboardExerciseEvent, HangboardExerciseState> {
//  final FirestoreHangboardExercisesRepository firestore;
//  final HangboardWorkout hangboardWorkout;

  HangboardExerciseBloc()
      : super(HangboardExerciseState(hangboardExerciseType: HangboardExerciseType.LOADING));

  @override
  Stream<HangboardExerciseState> mapEventToState(HangboardExerciseEvent event) async* {
    if (event is HangboardExerciseLoaded) {
      yield* _mapLoadHangboardExerciseToState(event);
    } else if (event is HangboardExercisePreferencesCleared) {
      yield* _mapClearHangboardExercisePreferencesToState(event);
    } else if (event is HangboardExerciseIncreaseNumberOfHangsButtonPressed) {
      yield* _mapHangboardExerciseIncreaseNumberOfHangsButtonPressedToState(event);
    } else if (event is HangboardExerciseDecreaseNumberOfHangsButtonPressed) {
      yield* _mapHangboardExerciseDecreaseNumberOfHangsButtonPressedToState(event);
    } else if (event is HangboardExerciseIncreaseNumberOfSetsButtonPressed) {
      yield* _mapHangboardExerciseIncreaseNumberOfSetsButtonPressedToState(event);
    } else if (event is HangboardExerciseDecreaseNumberOfSetsButtonPressed) {
      yield* _mapHangboardExerciseDecreaseNumberOfSetsButtonPressedToState(event);
    } else if (event is HangboardExerciseForwardComplete) {
      yield* _mapForwardCompletedToState(event);
    } else if (event is HangboardExerciseReverseComplete) {
      yield* _mapHangboardExerciseReverseCompleteToState(event);
    } else if (event is HangboardExerciseForwardSwitchButtonPressed) {
      yield* _mapHangboardExerciseForwardSwitchButtonPressedToState(event);
    } else if (event is HangboardExerciseReverseSwitchButtonPressed) {
      yield* _mapHangboardExerciseReverseSwitchButtonPressedToState(event);
    }
  }

  Stream<HangboardExerciseState> _mapLoadHangboardExerciseToState(
      HangboardExerciseLoaded event) async* {
    try {
      var loadedState = state.fromHangboardExercise(event.hangboardExercise);
      yield loadedState.update(
        //todo: doesn't seem like loading makes sense here - leaving for now since it's from the old project, but come back to this
        hangboardExerciseType: HangboardExerciseType.LOADED,
      );
    } catch (_) {
      yield state.update(hangboardExerciseType: HangboardExerciseType.FAILURE);
    }
  }

/*
  Stream<HangboardExerciseState> _mapHangboardExerciseCompleteToState(event) {
    return null;
  }*/

  //todo: doesn't look like this was implemented yet
  Stream<HangboardExerciseState> _mapClearHangboardExercisePreferencesToState(event) async* {
    yield null;
  }

  //todo: initial impression of what's going on here:
  /// Get the current hangsPerSet value in the state and compare with the original hangboardExercise
  /// value. Only update the state if the dynamic value has not exceeded the maximum number of hangs.
  /// Also update the timer to use the rep value
  Stream<HangboardExerciseState> _mapHangboardExerciseIncreaseNumberOfHangsButtonPressedToState(
      HangboardExerciseIncreaseNumberOfHangsButtonPressed event) async* {
    if (state.currentHangsPerSet < state.originalHangsPerSet) {
      yield state.update(
        currentHangsPerSet: state.currentHangsPerSet + 1,
        hangboardExerciseType: HangboardExerciseType.HANGS_TILE_UPDATE,
      );

      //todo: why are we doing this? leaving it for now to figure out but doesn't seem right
      event.timerBloc.add(TimerReplacedWithRepTimer(
        exerciseTitle: state.exerciseTitle,
        duration: state.repDuration,
        isTimerRunning: false,
      ));
    }
  }

  Stream<HangboardExerciseState> _mapHangboardExerciseDecreaseNumberOfHangsButtonPressedToState(
      HangboardExerciseDecreaseNumberOfHangsButtonPressed event) async* {
    if (state.currentHangsPerSet > 0) {
      yield state.update(
        currentHangsPerSet: state.currentHangsPerSet - 1,
        hangboardExerciseType: HangboardExerciseType.HANGS_TILE_UPDATE,
      );

      //todo: why are we doing this? leaving it for now to figure out but doesn't seem right
      event.timerBloc.add(TimerReplacedWithRepTimer(
        exerciseTitle: state.exerciseTitle,
        duration: state.repDuration,
        isTimerRunning: false,
      ));
    }
  }

  Stream<HangboardExerciseState> _mapHangboardExerciseIncreaseNumberOfSetsButtonPressedToState(
      HangboardExerciseIncreaseNumberOfSetsButtonPressed event) async* {
    if (state.currentNumberOfSets < state.originalNumberOfSets) {
      yield state.update(
        currentNumberOfSets: state.currentNumberOfSets + 1,
        hangboardExerciseType: HangboardExerciseType.SETS_TILE_UPDATE,
      );

      event.timerBloc.add(TimerReplacedWithRepTimer(
        exerciseTitle: state.exerciseTitle,
        duration: state.repDuration,
        isTimerRunning: false,
      ));
    }
  }

  Stream<HangboardExerciseState> _mapHangboardExerciseDecreaseNumberOfSetsButtonPressedToState(
      HangboardExerciseDecreaseNumberOfSetsButtonPressed event) async* {
    if (state.currentNumberOfSets > 0) {
      yield state.update(
        currentNumberOfSets: state.currentNumberOfSets - 1,
        hangboardExerciseType: HangboardExerciseType.SETS_TILE_UPDATE,
      );

      event.timerBloc.add(TimerReplacedWithRepTimer(
        exerciseTitle: state.exerciseTitle,
        duration: state.repDuration,
        isTimerRunning: false,
      ));
    }
  }

  Stream<HangboardExerciseState> _mapHangboardExerciseForwardSwitchButtonPressedToState(
      HangboardExerciseForwardSwitchButtonPressed event) async* {
    yield state.update(
      hangboardExerciseType: HangboardExerciseType.SWITCH_BUTTON_PRESSED,
    );

    event.timerBloc.add(TimerReplacedWithRepTimer(
      exerciseTitle: state.exerciseTitle,
      duration: state.repDuration,
      isTimerRunning: false,
    ));
    //todo: if this is pressed after a replaceWithRepTimer event has just happened
    //todo: the state hasn't changed so nothing happens and it doesnt update
  }

  Stream<HangboardExerciseState> _mapHangboardExerciseReverseSwitchButtonPressedToState(
      HangboardExerciseReverseSwitchButtonPressed event) async* {
    yield state.update(
      hangboardExerciseType: HangboardExerciseType.SWITCH_BUTTON_PRESSED,
    );

    event.timerBloc.add(TimerReplacedWithRestTimer(
      exerciseTitle: state.exerciseTitle,
      duration: state.restDuration,
      isTimerRunning: false,
    ));
  }

  Stream<HangboardExerciseState> _mapForwardCompletedToState(
      HangboardExerciseForwardComplete event) async* {
    var hangs = state.currentHangsPerSet;
    var sets = state.currentNumberOfSets;

    /// Rest timer completing
    if (event.timer.timerType == TimerType.REST) {
      hangs--;
      if (hangs > 0) {
        yield state.update(
          currentHangsPerSet: hangs,
          hangboardExerciseType: HangboardExerciseType.TIMER_UPDATE,
        );

        event.timerBloc.add(TimerReplacedWithRepTimer(
          exerciseTitle: state.exerciseTitle,
          duration: state.repDuration,
          isTimerRunning: true,
        ));
      } else {
        yield state.update(
          currentHangsPerSet: 0,
          hangboardExerciseType: HangboardExerciseType.TIMER_UPDATE,
        );

        event.timerBloc.add(TimerReplacedWithBreakTimer(
          exerciseTitle: state.exerciseTitle,
          duration: state.repDuration,
          isTimerRunning: true,
        ));
      }
    } else {
      /// Break timer completing
      if (sets > 0) {
        sets--;
        yield state.update(
          currentHangsPerSet: state.originalHangsPerSet,
          currentNumberOfSets: sets,
          hangboardExerciseType: HangboardExerciseType.TIMER_UPDATE,
        );

        event.timerBloc.add(TimerReplacedWithRepTimer(
          exerciseTitle: state.exerciseTitle,
          duration: state.repDuration,
          isTimerRunning: true,
        ));
      } else {
        yield state.update(
          currentHangsPerSet: 0,
          hangboardExerciseType: HangboardExerciseType.TIMER_UPDATE,
        );

        event.timerBloc.add(TimerReplacedWithRepTimer(
          exerciseTitle: state.exerciseTitle,
          duration: state.repDuration,
          isTimerRunning: false,
        ));
      }
    }
  }

  Stream<HangboardExerciseState> _mapHangboardExerciseReverseCompleteToState(
      HangboardExerciseReverseComplete event) async* {
    /// Rep timer completing always results in restTimer
    yield state.update(hangboardExerciseType: HangboardExerciseType.TIMER_UPDATE);

    event.timerBloc.add(TimerReplacedWithRestTimer(
      exerciseTitle: state.exerciseTitle,
      duration: state.restDuration,
      isTimerRunning: true,
    ));
  }
}
