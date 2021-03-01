
//TODO: ADD COLOR??? ANYTHING ELSE I WANT TO ADD?

import 'package:crux/backend/repository/timer/timer_direction.dart';
import 'package:crux/backend/repository/timer/timer_type_enum.dart';

class TimerEntity {
  final String storageKey; // Lookup key for SharedPreferences
  final int duration;
  final TimerDirection direction;
  final bool previouslyRunning;
  final int deviceTimeOnExit; // In epoch milliseconds
  final double controllerValueOnExit; // Value of animationController
  final TimerType timerType;

  TimerEntity(
    this.storageKey,
    this.duration,
    this.direction,
    this.previouslyRunning,
    this.deviceTimeOnExit,
    this.controllerValueOnExit,
    this.timerType,
  );

  @override
  String toString() {
    return '''TimerEntity { 
    storageKey: $storageKey,
    duration: $duration,
    direction: $direction,
    previouslyRunning: $previouslyRunning,
    deviceTimeOnExit: $deviceTimeOnExit,
    controllerValueOnExit: $controllerValueOnExit,
    timerType: $timerType
    }''';
  }

  Map<String, Object> toJson() {
    return {
      "storageKey": storageKey,
      "duration": duration,
      "direction": direction,
      "previouslyRunning": previouslyRunning,
      "deviceTimeOnExit": deviceTimeOnExit,
      "controllerValueOnExit": controllerValueOnExit,
      "timerType": timerType,
    };
  }

  //todo: defaults here for timer that is just loaded and doesn't have sharedprefs yet?
  //todo: defaults should be what's passed in for exercise ideally
  static TimerEntity fromJson(Map<String, Object> json) {
    return TimerEntity(
      json["storageKey"] as String ?? '', //todo: make sure this works
      json["duration"] as int,
      json["direction"] as TimerDirection,
      json["previouslyRunning"] as bool,
      json["deviceTimeOnExit"] as int,
      json["controllerValueOnExit"] as double,
      json["timerType"] as TimerType
    );
  }
}
