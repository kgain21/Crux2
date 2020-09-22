import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class HangboardFormEvent extends Equatable {
  const HangboardFormEvent();
}

class HangboardFormResistanceMeasurementSystemChanged extends HangboardFormEvent {
  final String resistanceMeasurementSystem;

  HangboardFormResistanceMeasurementSystemChanged(
      this.resistanceMeasurementSystem);

  @override
  String toString() =>
      'HangboardFormResistanceMeasurementSystemChanged { resistanceMeasurementSystem: $resistanceMeasurementSystem }';

  @override
  List<Object> get props => [resistanceMeasurementSystem];
}

class HangboardFormDepthMeasurementSystemChanged extends HangboardFormEvent {
  final String depthMeasurementSystem;

  HangboardFormDepthMeasurementSystemChanged(this.depthMeasurementSystem);

  @override
  String toString() =>
      'HangboardFormDepthMeasurementSystemChanged { depthMeasurementSystem: $depthMeasurementSystem }';

  @override
  List<Object> get props => [depthMeasurementSystem];
}

class HangboardFormNumberOfHandsChanged extends HangboardFormEvent {
  final int numberOfHandsSelected;

  HangboardFormNumberOfHandsChanged(this.numberOfHandsSelected);

  @override
  String toString() =>
      'HangboardFormNumberOfHandsChanged { numberOfHands: $numberOfHandsSelected }';

  @override
  List<Object> get props => [numberOfHandsSelected];
}

class HangboardFormHoldChanged extends HangboardFormEvent {
  final Hold hold;

  HangboardFormHoldChanged(this.hold);

  @override
  String toString() => 'HangboardFormHoldChanged { hold: $hold }';

  @override
  List<Object> get props => [hold];
}

class HangboardFormFingerConfigurationChanged extends HangboardFormEvent {
  final FingerConfiguration fingerConfiguration;

  HangboardFormFingerConfigurationChanged(this.fingerConfiguration);

  @override
  String toString() =>
      'HangboardFormFingerConfigurationChanged { fingerConfiguration: $fingerConfiguration }';

  @override
  List<Object> get props => [fingerConfiguration];
}

class HangboardFormDepthChanged extends HangboardFormEvent {
  final String depth;

  HangboardFormDepthChanged(this.depth);

  @override
  String toString() => 'HangboardFormDepthChanged { depth: $depth }';

  @override
  List<Object> get props => [depth];
}

class HangboardFormTimeOffChanged extends HangboardFormEvent {
  final String timeOff;

  HangboardFormTimeOffChanged(this.timeOff);

  @override
  String toString() => 'HangboardFormTimeOffChanged { timeOff: $timeOff }';

  @override
  List<Object> get props => [timeOff];
}

class HangboardFormTimeOnChanged extends HangboardFormEvent {
  final String timeOn;

  HangboardFormTimeOnChanged(this.timeOn);

  @override
  String toString() => 'HangboardFormTimeOnChanged { timeOn: $timeOn }';

  @override
  List<Object> get props => [timeOn];
}

class HangboardFormHangsPerSetChanged extends HangboardFormEvent {
  final String hangsPerSet;

  HangboardFormHangsPerSetChanged(this.hangsPerSet);

  @override
  String toString() =>
      'HangboardFormHangsPerSetChanged { hangsPerSet: $hangsPerSet }';

  @override
  List<Object> get props => [hangsPerSet];
}

class HangboardFormTimeBetweenSetsChanged extends HangboardFormEvent {
  final String timeBetweenSets;

  HangboardFormTimeBetweenSetsChanged(this.timeBetweenSets);

  @override
  String toString() =>
      'HangboardFormTimeBetweenSetsChanged { timeBetweenSets: $timeBetweenSets }';

  @override
  List<Object> get props => [timeBetweenSets];
}

class HangboardFormNumberOfSetsChanged extends HangboardFormEvent {
  final String numberOfSets;

  HangboardFormNumberOfSetsChanged(this.numberOfSets);

  @override
  String toString() =>
      'HangboardFormNumberOfSetsChanged { numberOfSets: $numberOfSets }';

  @override
  List<Object> get props => [numberOfSets];
}

class HangboardFormResistanceChanged extends HangboardFormEvent {
  final String resistance;

  HangboardFormResistanceChanged(this.resistance);

  @override
  String toString() =>
      'HangboardFormResistanceChanged { resistance: $resistance }';

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
  final String resistanceMeasurementSystem;
  final String depthMeasurementSystem;
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
