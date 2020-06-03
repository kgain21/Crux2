import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class CalendarDateChanged extends DashboardEvent {
  final DateTime selectedDate;
  final CruxUser cruxUser;

  const CalendarDateChanged({@required this.cruxUser, @required this.selectedDate});

  @override
  List<Object> get props => [];

  @override
  String toString() => '''CalendarDateChanged: { cruxUser: $cruxUser, selectedDate: $selectedDate } ''';
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
