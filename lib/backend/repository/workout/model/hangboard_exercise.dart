import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class HangboardExercise {
  final String exerciseTitle;
  final String depthMeasurementSystem;
  final String resistanceMeasurementSystem;
  final int numberOfHands;
  final String holdType;
  final String fingerConfiguration;
  final double holdDepth;
  final int hangsPerSet;
  final int numberOfSets;
  final int resistance;
  final int breakDuration;
  final int repDuration;
  final int restDuration;

  HangboardExercise(
    this.exerciseTitle,
    this.depthMeasurementSystem,
    this.resistanceMeasurementSystem,
    this.numberOfHands,
    this.holdType,
    this.fingerConfiguration,
    this.holdDepth,
    this.hangsPerSet,
    this.numberOfSets,
    this.resistance,
    this.breakDuration,
    this.repDuration,
    this.restDuration,
  );
}
