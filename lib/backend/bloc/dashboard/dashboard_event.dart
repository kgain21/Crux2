import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class CalendarDateChanged extends DashboardEvent {
  final DateTime selectedDate;

  const CalendarDateChanged({@required this.selectedDate});

  @override
  List<Object> get props => [];
}

class GetStartedButtonPressed extends DashboardEvent {
  const GetStartedButtonPressed();

  @override
  List<Object> get props => [];
}

class TabChanged extends DashboardEvent {
  final int tabIndex;

  const TabChanged({@required this.tabIndex});

  @override
  List<Object> get props => [];
}
