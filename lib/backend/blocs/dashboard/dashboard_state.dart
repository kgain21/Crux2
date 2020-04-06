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
