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

  final bool showTimeBetweenSets;
  final bool showDepth;

  final DepthUnit depthUnit;
  final ResistanceUnit resistanceUnit;
  final int hands;
  final Hold hold;
  final FingerConfiguration fingerConfiguration;

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
    this.showTimeBetweenSets,
    this.hands,
    this.hold,
    this.availableFingerConfigurations,
    this.fingerConfiguration,
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
      showTimeBetweenSets: true,
      hands: 2,
      hold: null,
      fingerConfiguration: null,
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
    bool showTimeBetweenSets,
    int hands,
    Hold hold,
    FingerConfiguration fingerConfiguration,
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
      showTimeBetweenSets: showTimeBetweenSets,
      hands: hands,
      hold: hold,
      fingerConfiguration: fingerConfiguration,
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
    bool showTimeBetweenSets,
    int hands,
    Hold hold,
    FingerConfiguration fingerConfiguration,
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
      showTimeBetweenSets: showTimeBetweenSets ?? this.showTimeBetweenSets,
      hands: hands ?? this.hands,
      hold: hold ?? this.hold,
      fingerConfiguration: fingerConfiguration ?? this.fingerConfiguration,
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
      showTimeBetweenSets: $showTimeBetweenSets,
      hands: $hands,
      hold: $hold,
      fingerConfiguration: $fingerConfiguration,
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
        showTimeBetweenSets,
        hands,
        hold,
        availableFingerConfigurations,
        fingerConfiguration,
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
}
