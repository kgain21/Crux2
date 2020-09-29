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
  final String timeBetweenSets;

  TimeBetweenSetsChanged(this.timeBetweenSets);

  @override
  String toString() => 'TimeBetweenSetsChanged { timeBetweenSets: $timeBetweenSets }';

  @override
  List<Object> get props => [timeBetweenSets];
}

class HangboardFormNumberOfSetsChanged extends HangboardFormEvent {
  final String numberOfSets;

  HangboardFormNumberOfSetsChanged(this.numberOfSets);

  @override
  String toString() => 'HangboardFormNumberOfSetsChanged { numberOfSets: $numberOfSets }';

  @override
  List<Object> get props => [numberOfSets];
}

class HangboardFormResistanceChanged extends HangboardFormEvent {
  final String resistance;

  HangboardFormResistanceChanged(this.resistance);

  @override
  String toString() => 'HangboardFormResistanceChanged { resistance: $resistance }';

  @override
  List<Object> get props => [resistance];
}

class HangboardFormFlagsReset extends HangboardFormEvent {
  HangboardFormFlagsReset();

  @override
  String toString() => 'HangboardFormFlagsReset';

  @override
  List<Object> get props => [];
}

//todo: simplify this to one save event?
class HangboardFormSaveInvalid extends HangboardFormEvent {
  HangboardFormSaveInvalid();

  @override
  String toString() => 'HangboardFormSaveInvalid';

  @override
  List<Object> get props => [];
}

class ValidHangboardFormSaved extends HangboardFormEvent {
  final ResistanceUnit resistanceMeasurementSystem;
  final DepthUnit depthMeasurementSystem;
  final int numberOfHandsSelected;
  final Hold hold;
  final FingerConfiguration fingerConfiguration;
  final String depth;
  final String timeOff;
  final String timeOn;
  final String timeBetweenSets;
  final String hangsPerSet;
  final String numberOfSets;
  final String resistance;

  ValidHangboardFormSaved(
    this.resistanceMeasurementSystem,
    this.depthMeasurementSystem,
    this.numberOfHandsSelected,
    this.hold,
    this.fingerConfiguration,
    this.depth,
    this.timeOff,
    this.timeOn,
    this.timeBetweenSets,
    this.hangsPerSet,
    this.numberOfSets,
    this.resistance,
  );

  @override
  String toString() => 'ValidHangboardFormSaved';

  @override
  List<Object> get props => [
        resistanceMeasurementSystem,
        depthMeasurementSystem,
        numberOfHandsSelected,
        hold,
        fingerConfiguration,
        depth,
        timeOff,
        timeOn,
        timeBetweenSets,
        hangsPerSet,
        numberOfSets,
        resistance,
      ];
}
