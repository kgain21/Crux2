import 'dart:convert';

import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/serialization/serializers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resource/resource.dart';

import '../test_model_factory.dart';

void main() async {
  var workoutResource = const Resource('test/resource/workout/test_workout.json');
  var testWorkout = await workoutResource.readAsString();
  Map<String, dynamic> testWorkoutJson = json.decode(testWorkout);

  group('workout serialization', () {
    test('given complete workout object, should serialize properly', () {
      CruxWorkout expectedCruxWorkout = TestModelFactory.getTypicalCruxWorkout();

      CruxWorkout actualCruxWorkout =
          serializers.deserializeWith(CruxWorkout.serializer, testWorkoutJson);

      assert(null != expectedCruxWorkout);
      assert(null != actualCruxWorkout.campusBoardWorkout);
      assert(null != actualCruxWorkout.coreWorkout);
      assert(null != actualCruxWorkout.strengthWorkout);
      assert(null != actualCruxWorkout.stretchingWorkout);
      assert(null != actualCruxWorkout.climbingWorkout);
      assert(null != actualCruxWorkout.hangboardWorkout);
      assert(actualCruxWorkout == expectedCruxWorkout);
    });
  });
}