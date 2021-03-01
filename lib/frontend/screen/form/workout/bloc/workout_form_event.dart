import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class WorkoutFormEvent extends Equatable {
  const WorkoutFormEvent();
}

class WorkoutFormInitialized extends WorkoutFormEvent {
  final CruxUser cruxUser;
  final DateTime workoutDate;

  const WorkoutFormInitialized({
    @required this.cruxUser,
    @required this.workoutDate,
  });

  @override
  List<Object> get props => [cruxUser, workoutDate];

  @override
  String toString() =>
      '''WorkoutFormInitialized: { cruxUser: $cruxUser, workoutDate: $workoutDate }''';
}

class WorkoutFormClosed extends WorkoutFormEvent {

  const WorkoutFormClosed();

  @override
  List<Object> get props => [];

  @override
  String toString() =>
      '''WorkoutFormClosed''';
}
