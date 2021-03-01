import 'package:crux/backend/repository/timer/timer.dart';
import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/frontend/screen/workout/timer/bloc/timer_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardExerciseEvent extends Equatable {
  HangboardExerciseEvent();
}

class HangboardExerciseLoaded extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseLoaded({@required this.hangboardExercise});

  @override
  String toString() => 'HangboardExerciseLoaded { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseAdded extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseAdded(this.hangboardExercise);

  @override
  String toString() => 'HangboardExerciseAdded { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseUpdated extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseUpdated(this.hangboardExercise);

  @override
  String toString() => 'HangboardExerciseUpdated { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseDisposed extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseDisposed(this.hangboardExercise);

  @override
  String toString() => 'HangboardExerciseDisposed { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExercisePreferencesCleared extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExercisePreferencesCleared(this.hangboardExercise);

  @override
  String toString() => 'HangboardExercisePreferencesCleared { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseIncreaseNumberOfHangsButtonPressed extends HangboardExerciseEvent {
  final TimerBloc timerBloc;

  HangboardExerciseIncreaseNumberOfHangsButtonPressed(this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseIncreaseNumberOfHangsButtonPressed';

  @override
  List<Object> get props => [timerBloc];
}

class HangboardExerciseDecreaseNumberOfHangsButtonPressed extends HangboardExerciseEvent {
  final TimerBloc timerBloc;

  HangboardExerciseDecreaseNumberOfHangsButtonPressed(this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseDecreaseNumberOfHangsButtonPressed';

  @override
  List<Object> get props => [timerBloc];
}

class HangboardExerciseIncreaseNumberOfSetsButtonPressed extends HangboardExerciseEvent {
  final TimerBloc timerBloc;

  HangboardExerciseIncreaseNumberOfSetsButtonPressed(this.timerBloc);

  @override
  String toString() => 'HangboardExerciseIncreaseNumberOfSetsButtonPressed';

  @override
  List<Object> get props => [timerBloc];
}

class HangboardExerciseDecreaseNumberOfSetsButtonPressed extends HangboardExerciseEvent {
  final TimerBloc timerBloc;

  HangboardExerciseDecreaseNumberOfSetsButtonPressed(this.timerBloc);

  @override
  String toString() => 'HangboardExerciseDecreaseNumberOfSetsButtonPressed';

  @override
  List<Object> get props => [timerBloc];
}

class HangboardExerciseRepCompleted extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseRepCompleted(this.hangboardExercise);

  @override
  String toString() => 'HangboardExerciseRepCompleted { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseRestCompleted extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseRestCompleted(this.hangboardExercise);

  @override
  String toString() => 'HangboardExerciseRestCompleted { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseBreakCompleted extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseBreakCompleted(this.hangboardExercise);

  @override
  String toString() => 'HangboardExerciseBreakCompleted { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseForwardSwitchButtonPressed extends HangboardExerciseEvent {
  final TimerBloc timerBloc;

  HangboardExerciseForwardSwitchButtonPressed(this.timerBloc);

  @override
  String toString() => 'HangboardExerciseForwardSwitchButtonPressed';

  @override
  List<Object> get props => [timerBloc];
}

class HangboardExerciseReverseSwitchButtonPressed extends HangboardExerciseEvent {
  final TimerBloc timerBloc;

  HangboardExerciseReverseSwitchButtonPressed(this.timerBloc);

  @override
  String toString() => 'HangboardExerciseReverseSwitchButtonPressed';

  @override
  List<Object> get props => [timerBloc];
}

class HangboardExerciseForwardComplete extends HangboardExerciseEvent {
  final Timer timer;
  final TimerBloc timerBloc;

  HangboardExerciseForwardComplete(this.timer, this.timerBloc);

  @override
  String toString() => 'HangboardExerciseForwardComplete { timer: $timer }';

  @override
  List<Object> get props => [timer];
}

class HangboardExerciseReverseComplete extends HangboardExerciseEvent {
  final Timer timer;
  final TimerBloc timerBloc;

  HangboardExerciseReverseComplete(this.timer, this.timerBloc);

  @override
  String toString() => 'HangboardExerciseReverseComplete { timer: $timer }';

  @override
  List<Object> get props => [timer];
}

/*
class HangboardExerciseComplete extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseComplete(this.hangboardExercise)
      : super([hangboardExercise]);

  @override
  String toString() =>
      'HangboardExerciseComplete { hangboardExercise: $hangboardExercise }';
}*/
