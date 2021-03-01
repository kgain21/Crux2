import 'package:crux/backend/repository/timer/timer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerEvent extends Equatable {
  final String exerciseTitle;

  TimerEvent({@required this.exerciseTitle});

  @override
  List<Object> get props => [exerciseTitle];
}

class TimerLoaded extends TimerEvent {
  final int duration;
  final bool isTimerRunning;

  @override
  String toString() => 'TimerLoaded { exerciseTitle: $exerciseTitle, duration: $duration, isTimerRunning: $isTimerRunning }';

  TimerLoaded({
    @required exerciseTitle,
    @required this.duration,
    @required this.isTimerRunning,
  }) : super(exerciseTitle: exerciseTitle);

  @override
  List<Object> get props => [exerciseTitle, duration, isTimerRunning];
}

class TimerTapped extends TimerEvent {
  final Timer timer;
  final double controllerStartValue;

  TimerTapped({
    @required exerciseTitle,
    @required this.timer,
    @required this.controllerStartValue,
  }) : super(exerciseTitle: exerciseTitle);

  @override
  String toString() => '''TimerTapped { exerciseTitle: $exerciseTitle, timer: $timer, 
      controllerStartValue: $controllerStartValue }''';

  @override
  List<Object> get props => [exerciseTitle, timer];
}

class TimerLongPressed extends TimerEvent {
  final Timer timer;
  final double controllerStartValue;

  TimerLongPressed({
    @required exerciseTitle,
    @required this.timer,
    @required this.controllerStartValue,
  }) : super(exerciseTitle: exerciseTitle);

  @override
  String toString() => '''TimerLongPressed { exerciseTitle: $exerciseTitle, timer: $timer,
      controllerStartValue: $controllerStartValue }''';

  @override
  List<Object> get props => [exerciseTitle, timer];
}

class TimerCompleted extends TimerEvent {
  final Timer timer;

  TimerCompleted({
    @required exerciseTitle,
    @required this.timer,
  }) : super(exerciseTitle: exerciseTitle);

  @override
  String toString() => 'TimerCompleted { exerciseTitle: $exerciseTitle, timer: $timer }';

  @override
  List<Object> get props => [exerciseTitle, timer];
}

class TimerReplacedWithRepTimer extends TimerEvent {
  final int duration;
  final bool isTimerRunning;

  TimerReplacedWithRepTimer({
    @required exerciseTitle,
    @required this.duration,
    @required this.isTimerRunning,
  }) : super(exerciseTitle: exerciseTitle);

  @override
  String toString() => 'TimerReplacedWithRepTimer { exerciseTitle: $exerciseTitle, duration: $duration, isTimerRunning: $isTimerRunning }';

  @override
  List<Object> get props => [exerciseTitle, duration, isTimerRunning];
}

class TimerReplacedWithRestTimer extends TimerEvent {
  final int duration;
  final bool isTimerRunning;

  TimerReplacedWithRestTimer({
    @required exerciseTitle,
    @required this.duration,
    @required this.isTimerRunning,
  }) : super(exerciseTitle: exerciseTitle);

  @override
  String toString() => 'TimerReplacedWithRestTimer { exerciseTitle: $exerciseTitle, duration: $duration, isTimerRunning: $isTimerRunning }';

  @override
  List<Object> get props => [exerciseTitle, duration, isTimerRunning];
}

class TimerReplacedWithBreakTimer extends TimerEvent {
  final int duration;
  final bool isTimerRunning;

  TimerReplacedWithBreakTimer({
    @required exerciseTitle,
    @required this.duration,
    @required this.isTimerRunning,
  }) : super(exerciseTitle: exerciseTitle);

  @override
  String toString() => 'TimerReplacedWithBreakTimer { exerciseTitle: $exerciseTitle, hangboardExercise: $duration, isTimerRunning: $isTimerRunning }';

  @override
  List<Object> get props => [exerciseTitle, duration, isTimerRunning];
}

class TimerDisposed extends TimerEvent {
  final Timer timer;

  TimerDisposed({
    @required exerciseTitle,
    @required this.timer,
  }) : super(exerciseTitle: exerciseTitle);

  @override
  String toString() => 'TimerDisposed { exerciseTitle: $exerciseTitle, timer: $timer }';

  @override
  List<Object> get props => [exerciseTitle, timer];
}

class TimerPreferencesCleared extends TimerEvent {
  final Timer timer;

  TimerPreferencesCleared({
    @required exerciseTitle,
    @required this.timer,
  }) : super(exerciseTitle: exerciseTitle);

  @override
  String toString() => 'TimerPreferencesCleared { exerciseTitle: $exerciseTitle, timer: $timer }';

  @override
  List<Object> get props => [exerciseTitle, timer];
}
