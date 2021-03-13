import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class DashboardState extends Equatable {
  //todo: revisit this - do I want to have named states like this or mirror the form state instead?
  final DateTime selectedDate;

  const DashboardState(this.selectedDate);

  @override
  List<Object> get props => [];
}

class DashboardUninitialized extends DashboardState {
  const DashboardUninitialized() : super(null);
}

class DashboardDateChangeInProgress extends DashboardState {
  const DashboardDateChangeInProgress() : super(null);
}

class DashboardDateChangeSuccess extends DashboardState {
  final CruxWorkout cruxWorkout;
  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate, cruxWorkout];

  @override
  String toString() =>
      '''DashboardDateChangeComplete: { selectedDate: $selectedDate, cruxWorkout: $cruxWorkout }''';

  const DashboardDateChangeSuccess({@required this.selectedDate, @required this.cruxWorkout})
      : super(selectedDate);
}

class DashboardDateChangeError extends DashboardState {
  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate];

  @override
  String toString() => '''DashboardDateChangeError: { selectedDate: $selectedDate }''';

  const DashboardDateChangeError({@required this.selectedDate}) : super(selectedDate);
}

class DashboardDateChangeNotFound extends DashboardState {
  final DateTime selectedDate;
  final CruxWorkout cruxWorkout;

  @override
  List<Object> get props => [selectedDate, cruxWorkout];

  @override
  String toString() =>
      '''DashboardDateChangeNotFound: { selectedDate: $selectedDate, cruxWorkout: $cruxWorkout }''';

  const DashboardDateChangeNotFound({@required this.selectedDate, @required this.cruxWorkout})
      : super(selectedDate);
}