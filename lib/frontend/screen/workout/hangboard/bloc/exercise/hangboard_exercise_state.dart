import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/model/hangboard/finger_configuration.dart';
import 'package:crux/model/hangboard/hang_protocol.dart';
import 'package:crux/model/hangboard/hold.dart';
import 'package:crux/model/hangboard/unit.dart';
import 'package:crux/util/null_util.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum HangboardExerciseType {
  LOADING,
  LOADED,
  FAILURE,
  HANGS_TILE_UPDATE,
  SETS_TILE_UPDATE,
  TIMER_UPDATE,
  SWITCH_BUTTON_PRESSED,
  EDITING,
}

@immutable
class HangboardExerciseState extends Equatable {
  final HangboardExerciseType hangboardExerciseType;
  final String exerciseTitle;

  final String depthUnit;
  final String resistanceUnit;
  final int hands;
  final String hangProtocol;
  final String hold;
  final String fingerConfiguration;

  final double depth;
  final int restDuration;
  final int repDuration;
  final int breakDuration;

  final int originalHangsPerSet;
  final int currentHangsPerSet;

  final int originalNumberOfSets;
  final int currentNumberOfSets;

  final double resistance;

  HangboardExerciseState({
    this.hangboardExerciseType,
    this.exerciseTitle,
    this.depthUnit,
    this.resistanceUnit,
    this.hands,
    this.hold,
    this.hangProtocol,
    this.fingerConfiguration,
    this.depth,
    this.restDuration,
    this.repDuration,
    this.breakDuration,
    this.originalHangsPerSet,
    this.currentHangsPerSet,
    this.originalNumberOfSets,
    this.currentNumberOfSets,
    this.resistance,
  });

  HangboardExerciseState update({
    HangboardExerciseType hangboardExerciseType,
    String exerciseTitle,
    DepthUnit depthUnit,
    ResistanceUnit resistanceUnit,
    int hands,
    HangProtocol hangProtocol,
    Hold hold,
    Nullable<FingerConfiguration> fingerConfiguration,
    Nullable<double> depth,
    Nullable<int> restDuration,
    int repDuration,
    int breakDuration,
    int originalHangsPerSet,
    int currentHangsPerSet,
    int originalNumberOfSets,
    int currentNumberOfSets,
    Nullable<double> resistance,
  }) {
    return HangboardExerciseState(
      hangboardExerciseType: hangboardExerciseType ?? this.hangboardExerciseType,
      exerciseTitle: exerciseTitle ?? this.exerciseTitle,
      depthUnit: depthUnit ?? this.depthUnit,
      resistanceUnit: resistanceUnit ?? this.resistanceUnit,
      hands: hands ?? this.hands,
      hangProtocol: hangProtocol ?? this.hangProtocol,
      hold: hold ?? this.hold,
      fingerConfiguration:
          fingerConfiguration == null ? this.fingerConfiguration : fingerConfiguration.value,
      depth: depth == null ? this.depth : depth.value,
      restDuration: restDuration == null ? this.restDuration : restDuration.value,
      repDuration: repDuration ?? this.repDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      originalHangsPerSet: originalHangsPerSet ?? this.originalHangsPerSet,
      currentHangsPerSet: currentHangsPerSet ?? this.currentHangsPerSet,
      originalNumberOfSets: originalNumberOfSets ?? this.originalNumberOfSets,
      currentNumberOfSets: currentNumberOfSets ?? this.currentNumberOfSets,
      resistance: resistance == null ? this.resistance : resistance.value,
    );
  }

  @override
  String toString() {
    return '''HangboardExerciseState {
      hangboardExerciseType: $hangboardExerciseType,
      exerciseTitle: $exerciseTitle,
      depthUnit: $depthUnit,
      resistanceUnit: $resistanceUnit,
      hands: $hands,
      hangProtocol: $hangProtocol,
      hold: $hold,
      fingerConfiguration: $fingerConfiguration,
      depth: $depth,
      restDuration: $restDuration,
      repDuration: $repDuration,
      breakDuration: $breakDuration,
      originalHangsPerSet: $originalHangsPerSet,
      hangsPerSet: $currentHangsPerSet,
      originalNumberOfSets: $originalNumberOfSets,
      numberOfSets: $currentNumberOfSets,
      resistance: $resistance
    }''';
  }

  @override
  List<Object> get props => [
        hangboardExerciseType,
        exerciseTitle,
        depthUnit,
        resistanceUnit,
        hands,
        hangProtocol,
        hold,
        fingerConfiguration,
        depth,
        restDuration,
        repDuration,
        breakDuration,
        originalHangsPerSet,
        currentHangsPerSet,
        originalNumberOfSets,
        currentNumberOfSets,
        resistance
      ];

  HangboardExerciseState fromHangboardExercise(HangboardExercise hangboardExercise) {
    return HangboardExerciseState(
      hangboardExerciseType: HangboardExerciseType.LOADED,
      exerciseTitle: hangboardExercise.exerciseTitle,
      depthUnit: hangboardExercise.depthUnit,
      resistanceUnit: hangboardExercise.resistanceUnit,
      hands: hangboardExercise.hands,
      hangProtocol: hangboardExercise.hangProtocol,
      hold: hangboardExercise.hold,
      fingerConfiguration: hangboardExercise.fingerConfiguration,
      depth: hangboardExercise.depth,
      restDuration: hangboardExercise.restDuration,
      repDuration: hangboardExercise.repDuration,
      breakDuration: hangboardExercise.breakDuration,
      originalHangsPerSet: hangboardExercise.hangsPerSet,
      currentHangsPerSet: hangboardExercise.hangsPerSet,
      originalNumberOfSets: hangboardExercise.numberOfSets,
      currentNumberOfSets: hangboardExercise.numberOfSets,
      resistance: hangboardExercise.resistance,
    );
  }
  //todo: random thought but not sure we need toExercise? Unless I want to store a notes field in there? tbd but doesn't seem like we'd need to update the exercise here really
  HangboardExercise toHangboardExercise() {
    return HangboardExercise((he) => he
      ..exerciseTitle = exerciseTitle
      ..depthUnit = depthUnit
      ..resistanceUnit = resistanceUnit
      ..hands = hands
      ..hangProtocol = hangProtocol
      ..hold = hold
      ..fingerConfiguration = fingerConfiguration
      ..depth = depth
      ..restDuration = restDuration
      ..repDuration = repDuration
      ..breakDuration = breakDuration
      ..hangsPerSet = originalHangsPerSet
      ..numberOfSets = originalNumberOfSets
      ..resistance = resistance);
  }
}
