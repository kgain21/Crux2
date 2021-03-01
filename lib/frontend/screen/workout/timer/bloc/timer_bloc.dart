import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/shared_preferences/preferences.dart';
import 'package:crux/backend/repository/timer/timer.dart';
import 'package:crux/backend/repository/timer/timer_direction.dart';
import 'package:crux/backend/repository/timer/timer_type_enum.dart';
import 'package:crux/frontend/screen/workout/timer/bloc/timer_event.dart';
import 'package:crux/frontend/screen/workout/timer/bloc/timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
//  final String exerciseTitle;

  TimerBloc() : super(TimerLoadInProgress());

  /*final HangboardExerciseBloc hangboardExerciseBloc;
  StreamSubscription hangboardExerciseSubscription;

  /// Listens for [HangboardExercise] to be created before dispatching to
  /// [LoadTimer].
  TimerBloc({@required this.hangboardExerciseBloc}) {
    hangboardExerciseSubscription = hangboardExerciseBloc.state.listen((
        state) { //TODO: how often will this rebuild???
      if(state is HangboardExerciseLoaded) {
        dispatch(LoadTimer(state.hangboardExercise));
      }
    });
  }*/

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is TimerLoaded) {
      yield* _mapTimerLoadedToState(event);
    } else if (event is TimerCompleted) {
      yield* _mapTimerCompleteToState(event);
    } else if (event is TimerReplacedWithRepTimer) {
      yield* _mapTimerReplacedWithRepTimerToState(event);
    } else if (event is TimerTapped) {
      yield* _mapTimeTappedToState(event);
    } else if (event is TimerLongPressed) {
      yield* _mapTimerLongPressedToState(event);
    } else if (event is TimerReplacedWithRestTimer) {
      yield* _mapTimerReplacedWithRestTimerToState(event);
    } else if (event is TimerReplacedWithBreakTimer) {
      yield* _mapTimerReplacedWithBreakTimerToState(event);
    } else if (event is TimerDisposed) {
      yield* _mapTimerDisposedToState(event);
    } else if (event is TimerPreferencesCleared) {
      yield* _mapClearTimerPreferencesToState(event);
    }
  }

  /// Loading the [Timer] assumes that this is the first time the user has// todo: <- not necessarily, if I'm listening to hbexerciseLoaded it should just pass in the new exercise each time and I can build off that right?
  /// interacted with this particular [Timer] since its workout has been loaded.
  /// [SharedPreferences] are checked and if none are found a [Timer] is created
  /// based on the [HangboardExerciseWorkout]. This [Timer] defaults to animating
  /// counterclockwise and starting with a controller value of 1.0 since these
  /// values signify a 'Rep'.
  ///
  /// If [SharedPreferences] are found, than the user has interacted with this
  /// [Timer] before and navigated away. The appropriate controller value is
  /// calculated based on how much time has elapsed and is passed back to
  /// the ExercisePage.
  Stream<TimerState> _mapTimerLoadedToState(TimerLoaded event) async* {
    try {
      final timerEntity = Preferences().getTimerPreferences(event.exerciseTitle);

      if (timerEntity != null) {
        Timer timer = Timer.fromEntity(timerEntity);
        double controllerValue = determineControllerValue(timer);
        yield TimerLoadSuccess(timer: timer, controllerStartValue: controllerValue);
      } else {
        yield TimerLoadSuccess(
            timer: Timer(
              storageKey: event.exerciseTitle,
              duration: event.duration,
              direction: TimerDirection.COUNTERCLOCKWISE,
              isTimerRunning: false,
              deviceTimeOnExit: 0,
              controllerValueOnExit: 1.0,
              timerType: TimerType.REP,
            ),
            controllerStartValue: 1.0);
      }
    } catch (exception) {
      print(exception);
      yield TimerLoadFailure();
    }
  }

  Stream<TimerState> _mapTimerReplacedWithRepTimerToState(TimerReplacedWithRepTimer event) async* {
    yield TimerLoadSuccess(
        timer: Timer(
          storageKey: event.exerciseTitle,
          duration: event.duration,
          direction: TimerDirection.COUNTERCLOCKWISE,
          isTimerRunning: event.isTimerRunning,
          deviceTimeOnExit: 0,
          controllerValueOnExit: 1.0,
          timerType: TimerType.REP,
        ),
        controllerStartValue: 1.0);
  }

  Stream<TimerState> _mapTimerReplacedWithRestTimerToState(
      TimerReplacedWithRestTimer event) async* {
    yield TimerLoadSuccess(
        timer: Timer(
          storageKey: event.exerciseTitle,
          duration: event.duration,
          direction: TimerDirection.CLOCKWISE,
          isTimerRunning: event.isTimerRunning,
          deviceTimeOnExit: 0,
          controllerValueOnExit: 0.0,
          timerType: TimerType.REST,
        ),
        controllerStartValue: 0.0);
  }

  Stream<TimerState> _mapTimerReplacedWithBreakTimerToState(
      TimerReplacedWithBreakTimer event) async* {
    yield TimerLoadSuccess(
        timer: Timer(
          storageKey: event.exerciseTitle,
          duration: event.duration,
          direction: TimerDirection.CLOCKWISE,
          isTimerRunning: event.isTimerRunning,
          deviceTimeOnExit: 0,
          controllerValueOnExit: 0.0,
          timerType: TimerType.BREAK,
        ),
        controllerStartValue: 0.0);
  }

  Stream<TimerState> _mapTimeTappedToState(TimerTapped event) async* {
    yield TimerLoadSuccess(
        timer: event.timer.copyWith(
          isTimerRunning: !event.timer.isTimerRunning,
        ),
        controllerStartValue: event.controllerStartValue);
  }

  Stream<TimerState> _mapTimerLongPressedToState(TimerLongPressed event) async* {
    yield TimerLoadSuccess(
        timer: event.timer.copyWith(
          isTimerRunning: false,
          controllerValueOnExit: event.timer.controllerValueOnExit,
          deviceTimeOnExit: event.timer.duration,
        ),
        controllerStartValue: event.controllerStartValue);
  }

  Stream<TimerState> _mapTimerCompleteToState(event) {
    return null;
  }

  Stream<TimerState> _mapClearTimerPreferencesToState(event) {
    return null;
  }

  Stream<TimerState> _mapTimerDisposedToState(TimerDisposed event) async* {
    if (state is TimerLoaded) {
      _saveTimer(event.timer);
//      yield TimerDisposed();
    }
  }

  Future _saveTimer(Timer timer) {
    return Preferences().storeTimerPreferences(timer.storageKey, timer.toEntity());
  }

  double determineControllerValue(Timer timer) {
    if (timer.isTimerRunning) {
      return valueDifference(timer);
    } else {
      return timer.controllerValueOnExit;
    }
  }

  /// Finds the difference in time from the saved ending system time and the
  /// current system time and divides that by the starting duration to get the
  /// new value accounting for elapsed time.
  double valueDifference(Timer timer) {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

    int elapsedDuration = currentTimeMillis - timer.deviceTimeOnExit;

    double timerDurationOnExit = timer.controllerValueOnExit * (timer.duration * 1000.0);

    double value;

    /// If animating forward and the calculated value difference is less than 0,
    /// return 0.0 as the value (can't have a negative value).
    /// Else if difference is greater than 1, return 1.
    /// Finally, return calculated value if neither of the above are true.
    if (timer.direction == TimerDirection.CLOCKWISE) {
      value = (timerDurationOnExit + elapsedDuration) / (timer.duration * 1000.0);
      if (value <= 0.0) return 0.0;
    } else {
      value = (timerDurationOnExit - elapsedDuration) / (timer.duration * 1000.0);
      if (value >= 1) return 1.0;
    }
    return value;
  }
/*
  @override
  void dispose() {
    hangboardExerciseSubscription.cancel();
    super.dispose();
  }*/
}
