import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:crux/model/unit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class HangboardFormState extends Equatable {
  final String exerciseTitle;

  final bool autoValidate;

  final bool showFingerConfiguration;
  final List<FingerConfiguration> availableFingerConfigurations;

  final bool showRestDuration;
  final bool showDepth;

  final DepthUnit depthUnit;
  final ResistanceUnit resistanceUnit;
  final int hands;
  final Hold hold;
  final FingerConfiguration fingerConfiguration;

  final double depth;
  final int restDuration;
  final int repDuration;
  final int breakDuration;
  final int hangsPerSet;
  final int numberOfSets;
  final double resistance;

  final bool validDepth;
  final bool validTimeOff;
  final bool validTimeOn;
  final bool validHangsPerSet;
  final bool validTimeBetweenSets;
  final bool validNumberOfSets;
  final bool validResistance;

  final bool isSuccess;
  final bool isFailure;
  final bool isDuplicate;

  HangboardFormState({
    this.exerciseTitle,
    this.depthUnit,
    this.resistanceUnit,
    this.showDepth,
    this.autoValidate,
    this.showFingerConfiguration,
    this.showRestDuration,
    this.hands,
    this.hold,
    this.availableFingerConfigurations,
    this.fingerConfiguration,
    this.depth,
    this.restDuration,
    this.repDuration,
    this.breakDuration,
    this.hangsPerSet,
    this.numberOfSets,
    this.resistance,
    this.validDepth,
    this.validTimeOff,
    this.validTimeOn,
    this.validHangsPerSet,
    this.validTimeBetweenSets,
    this.validNumberOfSets,
    this.validResistance,
    this.isSuccess,
    this.isFailure,
    this.isDuplicate,
  });

  factory HangboardFormState.initial() {
    return HangboardFormState(
      exerciseTitle: null,
      depthUnit: DepthUnit.MILLIMETERS,
      resistanceUnit: ResistanceUnit.KILOGRAMS,
      showDepth: false,
      autoValidate: false,
      availableFingerConfigurations: FingerConfiguration.values,
      showFingerConfiguration: false,
      showRestDuration: true,
      hands: 2,
      hold: null,
      fingerConfiguration: null,
      depth: null,
      restDuration: null,
      repDuration: null,
      breakDuration: null,
      hangsPerSet: null,
      numberOfSets: null,
      resistance: null,
      validDepth: true,
      validTimeOff: true,
      validTimeOn: true,
      validHangsPerSet: true,
      validTimeBetweenSets: true,
      validNumberOfSets: true,
      validResistance: true,
      isSuccess: false,
      isFailure: false,
      isDuplicate: false,
    );
  }

  HangboardFormState update({
    String exerciseTitle,
    DepthUnit depthUnit,
    ResistanceUnit resistanceUnit,
    bool showDepth,
    bool autoValidate,
    List<FingerConfiguration> availableFingerConfigurations,
    bool showFingerConfiguration,
    bool showRestDuration,
    int hands,
    Hold hold,
    FingerConfiguration fingerConfiguration,
    double depth,
    int restDuration,
    int repDuration,
    int breakDuration,
    int hangsPerSet,
    int numberOfSets,
    double resistance,
    bool validDepth,
    bool validTimeOff,
    bool validTimeOn,
    bool validHangsPerSet,
    bool validTimeBetweenSets,
    bool validNumberOfSets,
    bool validResistance,
    bool isSuccess,
    bool isFailure,
    bool isDuplicate,
  }) {
    return copyWith(
      exerciseTitle: exerciseTitle,
      depthUnit: depthUnit,
      resistanceUnit: resistanceUnit,
      showDepth: showDepth,
      autoValidate: autoValidate,
      availableFingerConfigurations: availableFingerConfigurations,
      showFingerConfiguration: showFingerConfiguration,
      showRestDuration: showRestDuration,
      hands: hands,
      hold: hold,
      fingerConfiguration: fingerConfiguration,
      depth: depth,
      restDuration: restDuration,
      repDuration: repDuration,
      breakDuration: breakDuration,
      hangsPerSet: hangsPerSet,
      numberOfSets: numberOfSets,
      resistance: resistance,
      validDepth: validDepth,
      validTimeOff: validTimeOff,
      validTimeOn: validTimeOn,
      validHangsPerSet: validHangsPerSet,
      validTimeBetweenSets: validTimeBetweenSets,
      validNumberOfSets: validNumberOfSets,
      validResistance: validResistance,
      isSuccess: isSuccess,
      isFailure: isFailure,
      isDuplicate: isDuplicate,
    );
  }

  HangboardFormState copyWith({
    String exerciseTitle,
    DepthUnit depthUnit,
    ResistanceUnit resistanceUnit,
    bool showDepth,
    bool autoValidate,
    List<FingerConfiguration> availableFingerConfigurations,
    bool showFingerConfiguration,
    bool showRestDuration,
    int hands,
    Hold hold,
    FingerConfiguration fingerConfiguration,
    double depth,
    int restDuration,
    int repDuration,
    int breakDuration,
    int hangsPerSet,
    int numberOfSets,
    double resistance,
    bool validDepth,
    bool validTimeOff,
    bool validTimeOn,
    bool validHangsPerSet,
    bool validTimeBetweenSets,
    bool validNumberOfSets,
    bool validResistance,
    bool isSuccess,
    bool isFailure,
    bool isDuplicate,
  }) {
    return HangboardFormState(
      exerciseTitle: exerciseTitle ?? this.exerciseTitle,
      depthUnit: depthUnit ?? this.depthUnit,
      resistanceUnit: resistanceUnit ?? this.resistanceUnit,
      showDepth: showDepth ?? this.showDepth,
      autoValidate: autoValidate ?? this.autoValidate,
      availableFingerConfigurations:
          availableFingerConfigurations ?? this.availableFingerConfigurations,
      showFingerConfiguration: showFingerConfiguration ?? this.showFingerConfiguration,
      showRestDuration: showRestDuration ?? this.showRestDuration,
      hands: hands ?? this.hands,
      hold: hold ?? this.hold,
      fingerConfiguration: fingerConfiguration ?? this.fingerConfiguration,
      depth: depth ?? this.depth,
      restDuration: restDuration ?? this.restDuration,
      repDuration: repDuration ?? this.repDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      hangsPerSet: hangsPerSet ?? this.hangsPerSet,
      numberOfSets: numberOfSets ?? this.numberOfSets,
      resistance: resistance ?? this.resistance,
      validDepth: validDepth ?? this.validDepth,
      validTimeOff: validTimeOff ?? this.validTimeOff,
      validTimeOn: validTimeOn ?? this.validTimeOn,
      validHangsPerSet: validHangsPerSet ?? this.validHangsPerSet,
      validTimeBetweenSets: validTimeBetweenSets ?? this.validTimeBetweenSets,
      validNumberOfSets: validNumberOfSets ?? this.validNumberOfSets,
      validResistance: validResistance ?? this.validResistance,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isDuplicate: isDuplicate ?? this.isDuplicate,
    );
  }

  @override
  String toString() {
    return '''HangboardFormState {
      exerciseTitle: $exerciseTitle,
      depthUnit: $depthUnit,
      resistanceUnit: $resistanceUnit,
      showDepth: $showDepth,
      autoValidate: $autoValidate,
      availableFingerConfigurations: $availableFingerConfigurations,
      showFingerConfiguration: $showFingerConfiguration,
      showRestDuration: $showRestDuration,
      hands: $hands,
      hold: $hold,
      fingerConfiguration: $fingerConfiguration,
      depth: $depth,
      restDuration: $restDuration,
      repDuration: $repDuration,
      breakDuration: $breakDuration,
      hangsPerSet: $hangsPerSet,
      numberOfSets: $numberOfSets,
      resistance: $resistance,
      validDepth: $validDepth,
      validTimeOff: $validTimeOff,
      validTimeOn: $validTimeOn,
      validHangsPerSet: $validHangsPerSet,
      validTimeBetweenSets: $validTimeBetweenSets,
      validNumberOfSets: $validNumberOfSets,
      validResistance: $validResistance,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isDuplicate: $isDuplicate,
    }''';
  }

  @override
  List<Object> get props => [
        exerciseTitle,
        depthUnit,
        resistanceUnit,
        showDepth,
        autoValidate,
        showFingerConfiguration,
        showRestDuration,
        hands,
        hold,
        availableFingerConfigurations,
        fingerConfiguration,
        depth,
        restDuration,
        repDuration,
        breakDuration,
        hangsPerSet,
        numberOfSets,
        resistance,
        validDepth,
        validTimeOff,
        validTimeOn,
        validHangsPerSet,
        validTimeBetweenSets,
        validNumberOfSets,
        validResistance,
        isSuccess,
        isFailure,
        isDuplicate,
      ];

  HangboardExercise toHangboardExercise() {
    return HangboardExercise((he) => he
      ..exerciseTitle = exerciseTitle
      ..depthUnit = depthUnit.name
      ..resistanceUnit = resistanceUnit.name
      ..hands = hands
      ..hold = hold.name
      ..fingerConfiguration = fingerConfiguration.name
      ..depth = depth
      ..restDuration = restDuration
      ..repDuration = repDuration
      ..breakDuration = breakDuration
      ..hangsPerSet = hangsPerSet
      ..numberOfSets = numberOfSets
      ..resistance = resistance);
  }
}
