import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:crux/model/unit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class HangboardFormEvent extends Equatable {
  const HangboardFormEvent();
}

class ResistanceUnitChanged extends HangboardFormEvent {
  final ResistanceUnit resistanceUnit;

  ResistanceUnitChanged(this.resistanceUnit);

  @override
  String toString() => 'ResistanceUnitChanged { resistanceUnit: $resistanceUnit }';

  @override
  List<Object> get props => [resistanceUnit];
}

class DepthUnitChanged extends HangboardFormEvent {
  final DepthUnit depthUnit;

  DepthUnitChanged(this.depthUnit);

  @override
  String toString() => 'DepthUnitChanged { depthUnit: $depthUnit }';

  @override
  List<Object> get props => [depthUnit];
}

class HandsChanged extends HangboardFormEvent {
  final int hands;

  HandsChanged(this.hands);

  @override
  String toString() => 'HandsChanged { hands: $hands }';

  @override
  List<Object> get props => [hands];
}

class HoldChanged extends HangboardFormEvent {
  final Hold hold;

  HoldChanged(this.hold);

  @override
  String toString() => 'HoldChanged { hold: $hold }';

  @override
  List<Object> get props => [hold];
}

class FingerConfigurationChanged extends HangboardFormEvent {
  final FingerConfiguration fingerConfiguration;

  FingerConfigurationChanged(this.fingerConfiguration);

  @override
  String toString() => 'FingerConfigurationChanged { fingerConfiguration: $fingerConfiguration }';

  @override
  List<Object> get props => [fingerConfiguration];
}

class DepthChanged extends HangboardFormEvent {
  final double depth;

  DepthChanged(this.depth);

  @override
  String toString() => 'DepthChanged { depth: $depth }';

  @override
  List<Object> get props => [depth];
}

class RestDurationChanged extends HangboardFormEvent {
  final int restDuration;

  RestDurationChanged(this.restDuration);

  @override
  String toString() => 'RestDurationChanged { restDuration: $restDuration }';

  @override
  List<Object> get props => [restDuration];
}

class RepDurationChanged extends HangboardFormEvent {
  final int repDuration;

  RepDurationChanged(this.repDuration);

  @override
  String toString() => 'RepDurationChanged { repDuration: $repDuration }';

  @override
  List<Object> get props => [repDuration];
}

class HangsPerSetChanged extends HangboardFormEvent {
  final int hangsPerSet;

  HangsPerSetChanged(this.hangsPerSet);

  @override
  String toString() => 'HangsPerSetChanged { hangsPerSet: $hangsPerSet }';

  @override
  List<Object> get props => [hangsPerSet];
}

class BreakDurationChanged extends HangboardFormEvent {
  final int breakDuration;

  BreakDurationChanged(this.breakDuration);

  @override
  String toString() => 'BreakDurationChanged { breakDuration: $breakDuration }';

  @override
  List<Object> get props => [breakDuration];
}

class ShowRestDurationChanged extends HangboardFormEvent {
  final bool showRestDuration;

  ShowRestDurationChanged(this.showRestDuration);

  @override
  String toString() => 'ShowRestDurationChanged { showRestDuration: $showRestDuration }';

  @override
  List<Object> get props => [showRestDuration];
}

class NumberOfSetsChanged extends HangboardFormEvent {
  final int numberOfSets;

  NumberOfSetsChanged(this.numberOfSets);

  @override
  String toString() => 'NumberOfSetsChanged { numberOfSets: $numberOfSets }';

  @override
  List<Object> get props => [numberOfSets];
}

class ResistanceChanged extends HangboardFormEvent {
  final double resistance;

  ResistanceChanged(this.resistance);

  @override
  String toString() => 'ResistanceChanged { resistance: $resistance }';

  @override
  List<Object> get props => [resistance];
}

class ResetFlags extends HangboardFormEvent {
  ResetFlags();

  @override
  String toString() => 'ResetFlags';

  @override
  List<Object> get props => [];
}

//todo: simplify this to one save event?
class InvalidSave extends HangboardFormEvent {
  InvalidSave();

  @override
  String toString() => 'InvalidSave';

  @override
  List<Object> get props => [];
}

class ValidSave extends HangboardFormEvent {
  final CruxUser cruxUser;
  final CruxWorkout cruxWorkout;

  ValidSave({@required this.cruxUser, @required this.cruxWorkout});

  @override
  String toString() => 'ValidHangboardFormSaved { cruxUser: $cruxUser, cruxWorkout: $cruxWorkout }';

  @override
  List<Object> get props => [cruxUser, cruxWorkout];
}
