import 'dart:convert';

import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/serialization/serializers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resource/resource.dart';
import 'package:collection/collection.dart';

import '../test_model_factory.dart';

void main() async {
  //todo: left off here - want to use resource creation in save test - this lib is deprecated though and I need to find a new one
  var workoutResource = const Resource('test/resource/workout/test_workout.json');
  var testWorkout = await workoutResource.readAsString();
  Map<String, dynamic> testWorkoutJson = json.decode(testWorkout);

  group('workout serialization', () {
    test('given complete workout object, should deserialize properly', () {
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

    test('given complete workout object, should serialize properly', () {
      Map<String, dynamic> serializedCruxWorkout =
          serializers.serializeWith(CruxWorkout.serializer, TestModelFactory.getTypicalCruxWorkout());

      assert(null != serializedCruxWorkout);
      assert(serializedCruxWorkout.containsKey("campusBoardWorkout"));
      assert(serializedCruxWorkout.containsKey("coreWorkout"));
      assert(serializedCruxWorkout.containsKey("strengthWorkout"));
      assert(serializedCruxWorkout.containsKey("stretchingWorkout"));
      assert(serializedCruxWorkout.containsKey("climbingWorkout"));
      assert(serializedCruxWorkout.containsKey("hangboardWorkout"));
      assert(DeepCollectionEquality().equals(testWorkoutJson, serializedCruxWorkout));
    });
  });
}
