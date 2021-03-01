import 'package:crux/backend/repository/timer/timer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

///
/// Class containing the state of the CircularTimer used in Hangboard workouts.
///
/// This state is used to persist and retrieve timer state if a user leaves the
/// screen or application. Values are stored to look up the time that the user
/// left at, and calculate the elapsed time if it was left in a running state.
///
@immutable
abstract class TimerState extends Equatable {
  TimerState();
}

class TimerLoadInProgress extends TimerState {
  @override
  String toString() => 'TimerLoadInProgress';

  @override
  List<Object> get props => [];
}

class TimerLoadSuccess extends TimerState {
  final String exerciseTitle;
  final Timer timer;
  final double controllerStartValue;

  TimerLoadSuccess({
    @required this.exerciseTitle,
    @required this.timer,
    @required this.controllerStartValue,
  });

  @override
  String toString() {
    return '''TimerLoadSuccess: { 
      exerciseTitle: $exerciseTitle,
      timer: ${timer.toString()}, 
      controllerStartValue: $controllerStartValue 
    }''';
  }

  @override
  List<Object> get props => [exerciseTitle, timer, controllerStartValue];
}

class TimerLoadFailure extends TimerState {
  @override
  String toString() => 'TimerLoadFailure';

  @override
  List<Object> get props => [];
}
