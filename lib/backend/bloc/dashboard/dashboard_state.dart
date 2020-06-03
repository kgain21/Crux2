import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardUninitialized extends DashboardState {
  const DashboardUninitialized();
}

class DashboardInitialized extends DashboardState {
  const DashboardInitialized();
}

class DashboardDateChangeInProgress extends DashboardState {
  const DashboardDateChangeInProgress();
}

class DashboardDateChangeSuccess extends DashboardState {
  final CruxWorkout cruxWorkout;
  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate, cruxWorkout];

  @override
  String toString() =>
      '''DashboardDateChangeComplete: { selectedDate: $selectedDate, cruxWorkout: $cruxWorkout }''';

  const DashboardDateChangeSuccess({@required this.selectedDate, @required this.cruxWorkout});
}

class DashboardDateChangeError extends DashboardState {
  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate];

  @override
  String toString() => '''DashboardDateChangeError: { selectedDate: $selectedDate }''';

  const DashboardDateChangeError({@required this.selectedDate});
}

class DashboardDateChangeNotFound extends DashboardState {
  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate];

  @override
  String toString() => '''DashboardDateChangeNotFound: { selectedDate: $selectedDate }''';

  const DashboardDateChangeNotFound({@required this.selectedDate});
}
