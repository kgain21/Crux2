import 'package:built_collection/built_collection.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/campus_board_workout.dart';
import 'package:crux/backend/repository/workout/model/climbing_workout.dart';
import 'package:crux/backend/repository/workout/model/core_workout.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/repository/workout/model/hangboard_exercise.dart';
import 'package:crux/backend/repository/workout/model/hangboard_workout.dart';
import 'package:crux/backend/repository/workout/model/strength_workout.dart';
import 'package:crux/backend/repository/workout/model/stretching_workout.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_state.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:crux/model/unit.dart';

class TestModelFactory {
  static CruxWorkout getTypicalCruxWorkout() {
    return CruxWorkout((cw) {
      return cw
        ..workoutDate = DateTime.utc(2020, 5, 26, 12, 0, 0)
        ..hangboardWorkout = (HangboardWorkoutBuilder()
          ..workoutTitle = "Tuesday, May 26, 2020"
          ..hangboardExercises =
              (ListBuilder<HangboardExercise>([getTypicalHangboardExercise()])..build())
          ..build())
        ..climbingWorkout = (ClimbingWorkoutBuilder()..build())
        ..stretchingWorkout = (StretchingWorkoutBuilder()..build())
        ..strengthWorkout = (StrengthWorkoutBuilder()..build())
        ..coreWorkout = (CoreWorkoutBuilder()..build())
        ..campusBoardWorkout = (CampusBoardWorkoutBuilder()..build())
        ..build();
    });
  }

  //todo: add hang protocol to include repeaters, max hangs, etc.
  static HangboardExercise getTypicalHangboardExercise() {
    return HangboardExercise((he) => he
      ..breakDuration = 180
      ..depthUnit = DepthUnit.MILLIMETERS.abbreviation
      ..exerciseTitle = "2 Handed 12mm Index/Middle/Ring/Pinkie Half Crimp" //add "Repeaters" to this title
      ..fingerConfiguration = FingerConfiguration.INDEX_MIDDLE_RING_PINKIE.name
      ..hangsPerSet = 6
      ..depth = 12
      ..hold = Hold.HALF_CRIMP.name
      ..hands = 2
      ..numberOfSets = 4
      ..repDuration = 7
      ..resistance = 25
      ..resistanceUnit = ResistanceUnit.POUNDS.abbreviation
      ..restDuration = 3
      ..build());
  }

  static CruxUser getTypicalCruxUser() {
    return CruxUser(uid: '12345', displayName: 'Kyle Gain', email: 'abc123@gmail.com');
  }

  static HangboardFormState getTypicalOneHandedHangboardWorkoutFormState() {
    return HangboardFormState(
      exerciseTitle: "1 Handed 14mm Index/Middle/Ring/Pinkie Half Crimp",
      autoValidate: false,
      showFingerConfiguration: true,
      availableFingerConfigurations: [
        FingerConfiguration.INDEX_MIDDLE,
        FingerConfiguration.MIDDLE_RING,
        FingerConfiguration.RING_PINKIE,
        FingerConfiguration.INDEX_MIDDLE_RING,
        FingerConfiguration.MIDDLE_RING_PINKIE,
        FingerConfiguration.INDEX_MIDDLE_RING_PINKIE,
      ],
      showRestDuration: false,
      showDepth: true,
      depthUnit: DepthUnit.MILLIMETERS,
      resistanceUnit: ResistanceUnit.POUNDS,
      hands: 1,
      hold: Hold.HALF_CRIMP,
      fingerConfiguration: FingerConfiguration.INDEX_MIDDLE_RING_PINKIE,
      depth: 14.0,
      restDuration: null,
      repDuration: 10,
      breakDuration: 180,
      hangsPerSet: 1,
      numberOfSets: 6,
      showResistance: true,
      resistance: -25.0,
      validDepth: true,
      validRestDuration: true,
      validRepDuration: true,
      validHangsPerSet: true,
      validBreakDuration: true,
      validNumberOfSets: true,
      validResistance: true,
      isSuccess: true,
      isFailure: false,
      isDuplicate: false,
    );
  }

  static HangboardFormState getTypicalTwoHandedHangboardWorkoutFormState() {
    return HangboardFormState(
      exerciseTitle: "2 Handed 12mm Index/Middle/Ring/Pinkie Half Crimp",
      autoValidate: false,
      showFingerConfiguration: true,
      availableFingerConfigurations: [
        FingerConfiguration.INDEX_MIDDLE,
        FingerConfiguration.MIDDLE_RING,
        FingerConfiguration.RING_PINKIE,
        FingerConfiguration.INDEX_MIDDLE_RING,
        FingerConfiguration.MIDDLE_RING_PINKIE,
        FingerConfiguration.INDEX_MIDDLE_RING_PINKIE,
      ],
      showRestDuration: true,
      showDepth: true,
      depthUnit: DepthUnit.MILLIMETERS,
      resistanceUnit: ResistanceUnit.POUNDS,
      hands: 2,
      hold: Hold.HALF_CRIMP,
      fingerConfiguration: FingerConfiguration.INDEX_MIDDLE_RING_PINKIE,
      depth: 12.0,
      restDuration: 3,
      repDuration: 7,
      breakDuration: 180,
      hangsPerSet: 6,
      numberOfSets: 4,
      showResistance: true,
      resistance: 25.0,
      validDepth: true,
      validRestDuration: true,
      validRepDuration: true,
      validHangsPerSet: true,
      validBreakDuration: true,
      validNumberOfSets: true,
      validResistance: true,
      isSuccess: false,
      isFailure: false,
      isDuplicate: false,
    );
  }
}
