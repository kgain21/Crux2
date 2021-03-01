import 'package:crux/backend/repository/timer/timer_direction.dart';
import 'package:crux/backend/repository/timer/timer_entity.dart';
import 'package:crux/backend/repository/timer/timer_type_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';


@immutable
class Timer extends Equatable {
  final String storageKey; // Storage key for SharedPreferences
  final int duration;
  final TimerDirection direction;
  final bool isTimerRunning;
  final int deviceTimeOnExit; // In epoch milliseconds
  final double controllerValueOnExit; // Value of animationController
  final TimerType timerType;

  Timer({
    @required this.storageKey,
    @required this.duration,
    @required this.direction,
    @required this.isTimerRunning,
    @required this.deviceTimeOnExit,
    @required this.controllerValueOnExit,
    @required this.timerType,
  });

  Timer copyWith({
    String storageKey,
    int duration,
    TimerDirection direction,
    bool isTimerRunning,
    int deviceTimeOnExit,
    double controllerValueOnExit,
    TimerType timerType,
  }) {
    return Timer(
      storageKey: storageKey,
      duration: duration,
      direction: direction,
      isTimerRunning: isTimerRunning,
      deviceTimeOnExit: deviceTimeOnExit,
      controllerValueOnExit: controllerValueOnExit,
      timerType: timerType,
    );
  }

  @override
  String toString() {
    return '''Timer { 
    storageKey: $storageKey, 
    duration: $duration,
    direction: $direction,
    previouslyRunning: $isTimerRunning,
    deviceTimeOnExit: $deviceTimeOnExit, 
    controllerValueOnExit: $controllerValueOnExit,
    timerType: $timerType
    }''';
  }

  TimerEntity toEntity() {
    return TimerEntity(
      storageKey,
      duration,
      direction,
      isTimerRunning,
      deviceTimeOnExit,
      controllerValueOnExit,
      timerType,
    );
  }

  static Timer fromEntity(TimerEntity entity) {
    return Timer(
      storageKey: entity.storageKey,
      duration: entity.duration,
      direction: entity.direction,
      isTimerRunning: entity.previouslyRunning,
      deviceTimeOnExit: entity.deviceTimeOnExit,
      controllerValueOnExit: entity.controllerValueOnExit,
      timerType: entity.timerType,
    );
  }

  @override
  List<Object> get props => [
        storageKey,
        duration,
        direction,
        isTimerRunning,
        deviceTimeOnExit,
        controllerValueOnExit,
        timerType,
      ];
}
