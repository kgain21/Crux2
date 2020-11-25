import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hang_protocol.dart';
import 'package:crux/model/hold.dart';
import 'package:crux/model/unit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class HangboardFormEvent extends Equatable {
  const HangboardFormEvent();
}

abstract class DebounceEvent extends HangboardFormEvent {}

abstract class NonDebounceEvent extends HangboardFormEvent {}

class ResistanceUnitChanged extends NonDebounceEvent {
  final ResistanceUnit resistanceUnit;

  ResistanceUnitChanged(this.resistanceUnit);

  @override
  String toString() => 'ResistanceUnitChanged { resistanceUnit: $resistanceUnit }';

  @override
  List<Object> get props => [resistanceUnit];
}

class DepthUnitChanged extends NonDebounceEvent {
  final DepthUnit depthUnit;

  DepthUnitChanged(this.depthUnit);

  @override
  String toString() => 'DepthUnitChanged { depthUnit: $depthUnit }';

  @override
  List<Object> get props => [depthUnit];
}

class HandsChanged extends NonDebounceEvent {
  final int hands;

  HandsChanged(this.hands);

  @override
  String toString() => 'HandsChanged { hands: $hands }';

  @override
  List<Object> get props => [hands];
}

class HangProtocolChanged extends NonDebounceEvent {
  final HangProtocol hangProtocol;

  HangProtocolChanged(this.hangProtocol);

  @override
  String toString() => 'HangProtocolChanged { hangProtocol: $hangProtocol }';

  @override
  List<Object> get props => [hangProtocol];
}

class HoldChanged extends NonDebounceEvent {
  final Hold hold;

  HoldChanged(this.hold);

  @override
  String toString() => 'HoldChanged { hold: $hold }';

  @override
  List<Object> get props => [hold];
}

class FingerConfigurationChanged extends NonDebounceEvent {
  final FingerConfiguration fingerConfiguration;

  FingerConfigurationChanged(this.fingerConfiguration);

  @override
  String toString() => 'FingerConfigurationChanged { fingerConfiguration: $fingerConfiguration }';

  @override
  List<Object> get props => [fingerConfiguration];
}

class DepthChanged extends DebounceEvent {
  final double depth;

  DepthChanged(this.depth);

  @override
  String toString() => 'DepthChanged { depth: $depth }';

  @override
  List<Object> get props => [depth];
}

class RestDurationChanged extends DebounceEvent {
  final int restDuration;

  RestDurationChanged(this.restDuration);

  @override
  String toString() => 'RestDurationChanged { restDuration: $restDuration }';

  @override
  List<Object> get props => [restDuration];
}

class RepDurationChanged extends DebounceEvent {
  final int repDuration;

  RepDurationChanged(this.repDuration);

  @override
  String toString() => 'RepDurationChanged { repDuration: $repDuration }';

  @override
  List<Object> get props => [repDuration];
}

class HangsPerSetChanged extends DebounceEvent {
  final int hangsPerSet;

  HangsPerSetChanged(this.hangsPerSet);

  @override
  String toString() => 'HangsPerSetChanged { hangsPerSet: $hangsPerSet }';

  @override
  List<Object> get props => [hangsPerSet];
}

class BreakDurationChanged extends DebounceEvent {
  final int breakDuration;

  BreakDurationChanged(this.breakDuration);

  @override
  String toString() => 'BreakDurationChanged { breakDuration: $breakDuration }';

  @override
  List<Object> get props => [breakDuration];
}

class ShowRestDurationChanged extends NonDebounceEvent {
  final bool showRestDuration;

  ShowRestDurationChanged(this.showRestDuration);

  @override
  String toString() => 'ShowRestDurationChanged { showRestDuration: $showRestDuration }';

  @override
  List<Object> get props => [showRestDuration];
}

class NumberOfSetsChanged extends DebounceEvent {
  final int numberOfSets;

  NumberOfSetsChanged(this.numberOfSets);

  @override
  String toString() => 'NumberOfSetsChanged { numberOfSets: $numberOfSets }';

  @override
  List<Object> get props => [numberOfSets];
}

class ResistanceChanged extends DebounceEvent {
  final double resistance;

  ResistanceChanged(this.resistance);

  @override
  String toString() => 'ResistanceChanged { resistance: $resistance }';

  @override
  List<Object> get props => [resistance];
}

class ShowResistanceChanged extends NonDebounceEvent {
  final bool showResistance;

  ShowResistanceChanged(this.showResistance);

  @override
  String toString() => 'ShowResistanceChanged { showResistance: $showResistance }';

  @override
  List<Object> get props => [showResistance];
}

class ResetFlags extends NonDebounceEvent {
  ResetFlags();

  @override
  String toString() => 'ResetFlags';

  @override
  List<Object> get props => [];
}

//todo: simplify this to one save event?
class InvalidSave extends NonDebounceEvent {
  InvalidSave();

  @override
  String toString() => 'InvalidSave';

  @override
  List<Object> get props => [];
}

class ValidSave extends NonDebounceEvent {
  final CruxUser cruxUser;
  final CruxWorkout cruxWorkout;

  ValidSave({@required this.cruxUser, @required this.cruxWorkout});

  @override
  String toString() => 'ValidHangboardFormSaved { cruxUser: $cruxUser, cruxWorkout: $cruxWorkout }';

  @override
  List<Object> get props => [cruxUser, cruxWorkout];
}
