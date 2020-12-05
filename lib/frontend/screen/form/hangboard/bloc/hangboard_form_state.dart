import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hang_protocol.dart';
import 'package:crux/model/hold.dart';
import 'package:crux/model/unit.dart';
import 'package:crux/util/null_util.dart';
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
  final bool showResistance;

  final DepthUnit depthUnit;
  final ResistanceUnit resistanceUnit;
  final int hands;
  final HangProtocol hangProtocol;
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
  final bool validRestDuration;
  final bool validRepDuration;
  final bool validHangsPerSet;
  final bool validBreakDuration;
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
    this.hangProtocol,
    this.availableFingerConfigurations,
    this.fingerConfiguration,
    this.depth,
    this.restDuration,
    this.repDuration,
    this.breakDuration,
    this.hangsPerSet,
    this.numberOfSets,
    this.showResistance,
    this.resistance,
    this.validDepth,
    this.validRestDuration,
    this.validRepDuration,
    this.validHangsPerSet,
    this.validBreakDuration,
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
      hangProtocol: null,
      hold: null,
      fingerConfiguration: null,
      depth: null,
      restDuration: null,
      repDuration: null,
      breakDuration: null,
      hangsPerSet: null,
      numberOfSets: null,
      showResistance: false,
      resistance: null,
      validDepth: true,
      validRestDuration: false,
      validRepDuration: false,
      validHangsPerSet: false,
      validBreakDuration: false,
      validNumberOfSets: false,
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
    Nullable<List<FingerConfiguration>> availableFingerConfigurations,
    bool showFingerConfiguration,
    bool showRestDuration,
    int hands,
    HangProtocol hangProtocol,
    Hold hold,
    Nullable<FingerConfiguration> fingerConfiguration,
    Nullable<double> depth,
    Nullable<int> restDuration,
    int repDuration,
    int breakDuration,
    int hangsPerSet,
    int numberOfSets,
    bool showResistance,
    Nullable<double> resistance,
    bool validDepth,
    bool validRestDuration,
    bool validRepDuration,
    bool validHangsPerSet,
    bool validBreakDuration,
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
      availableFingerConfigurations: availableFingerConfigurations == null
          ? this.availableFingerConfigurations
          : availableFingerConfigurations.value,
      showFingerConfiguration: showFingerConfiguration ?? this.showFingerConfiguration,
      showRestDuration: showRestDuration ?? this.showRestDuration,
      hands: hands ?? this.hands,
      hangProtocol: hangProtocol ?? this.hangProtocol,
      hold: hold ?? this.hold,
      fingerConfiguration:
          fingerConfiguration == null ? this.fingerConfiguration : fingerConfiguration.value,
      depth: depth == null ? this.depth : depth.value,
      restDuration: restDuration == null ? this.restDuration : restDuration.value,
      repDuration: repDuration ?? this.repDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      hangsPerSet: hangsPerSet ?? this.hangsPerSet,
      numberOfSets: numberOfSets ?? this.numberOfSets,
      showResistance: showResistance ?? this.showResistance,
      resistance: resistance == null ? this.resistance : resistance.value,
      validDepth: validDepth ?? this.validDepth,
      validRestDuration: validRestDuration ?? this.validRestDuration,
      validRepDuration: validRepDuration ?? this.validRepDuration,
      validHangsPerSet: validHangsPerSet ?? this.validHangsPerSet,
      validBreakDuration: validBreakDuration ?? this.validBreakDuration,
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
      hangProtocol: $hangProtocol,
      hold: $hold,
      fingerConfiguration: $fingerConfiguration,
      depth: $depth,
      restDuration: $restDuration,
      repDuration: $repDuration,
      breakDuration: $breakDuration,
      hangsPerSet: $hangsPerSet,
      numberOfSets: $numberOfSets,
      showResistance: $showResistance,
      resistance: $resistance,
      validDepth: $validDepth,
      validRestDuration: $validRestDuration,
      validRepDuration: $validRepDuration,
      validHangsPerSet: $validHangsPerSet,
      validBreakDuration: $validBreakDuration,
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
        hangProtocol,
        hold,
        availableFingerConfigurations,
        fingerConfiguration,
        depth,
        restDuration,
        repDuration,
        breakDuration,
        hangsPerSet,
        numberOfSets,
        showResistance,
        resistance,
        validDepth,
        validRestDuration,
        validRepDuration,
        validHangsPerSet,
        validBreakDuration,
        validNumberOfSets,
        validResistance,
        isSuccess,
        isFailure,
        isDuplicate,
      ];

  HangboardExercise toHangboardExercise() {
    return HangboardExercise((he) => he
      ..exerciseTitle = exerciseTitle
      ..depthUnit = depthUnit.abbreviation
      ..resistanceUnit = resistanceUnit.abbreviation
      ..hands = hands
      ..hangProtocol = hangProtocol.name
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
