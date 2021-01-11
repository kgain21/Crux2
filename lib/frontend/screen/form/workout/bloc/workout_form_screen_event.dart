part of 'workout_form_screen_bloc.dart';

abstract class WorkoutFormEvent extends Equatable {
  const WorkoutFormEvent();
}

class WorkoutFormInitialized extends WorkoutFormEvent {

  const WorkoutFormInitialized();

  @override
  List<Object> get props => [];

  @override
  String toString() => '''WorkoutFormInitialized ''';
}
