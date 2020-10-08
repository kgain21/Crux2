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
  String toString() => 'ConfigurationChanged { fingerConfiguration: $fingerConfiguration }';

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

class TimeOffChanged extends HangboardFormEvent {
  final int timeOff;

  TimeOffChanged(this.timeOff);

  @override
  String toString() => 'TimeOffChanged { timeOff: $timeOff }';

  @override
  List<Object> get props => [timeOff];
}

class TimeOnChanged extends HangboardFormEvent {
  final int timeOn;

  TimeOnChanged(this.timeOn);

  @override
  String toString() => 'TimeOnChanged { timeOn: $timeOn }';

  @override
  List<Object> get props => [timeOn];
}

class HangsPerSetChanged extends HangboardFormEvent {
  final int hangsPerSet;

  HangsPerSetChanged(this.hangsPerSet);

  @override
  String toString() => 'HangsPerSetChanged { hangsPerSet: $hangsPerSet }';

  @override
  List<Object> get props => [hangsPerSet];
}

class TimeBetweenSetsChanged extends HangboardFormEvent {
  final int timeBetweenSets;

  TimeBetweenSetsChanged(this.timeBetweenSets);

  @override
  String toString() => 'TimeBetweenSetsChanged { timeBetweenSets: $timeBetweenSets }';

  @override
  List<Object> get props => [timeBetweenSets];
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

  ValidSave();

  @override
  String toString() => 'ValidHangboardFormSaved';

  @override
  List<Object> get props => [];
}
