import 'package:crux/backend/repository/workout/model/ab_workout.dart';
import 'package:crux/backend/repository/workout/model/campus_board_workout.dart';
import 'package:crux/backend/repository/workout/model/climbing_workout.dart';
import 'package:crux/backend/repository/workout/model/hangboard_workout.dart';
import 'package:crux/backend/repository/workout/model/strength_workout.dart';
import 'package:crux/backend/repository/workout/model/stretching_workout.dart';

class CruxWorkout {
  // don't think i need date here but leaving this comment as a future placeholder
  final HangboardWorkout hangboardWorkout;
  final CampusBoardWorkout campusBoardWorkout;
  final StrengthWorkout strengthWorkout;
  final AbWorkout abWorkout;
  final StretchingWorkout stretchingWorkout;
  final ClimbingWorkout climbingWorkout; // enum w/ ropes, bouldering, party wall, indoor, outdoor, etc.

  const CruxWorkout({this.hangboardWorkout,
    this.campusBoardWorkout,
    this.strengthWorkout,
    this.abWorkout,
    this.stretchingWorkout,
    this.climbingWorkout,
  });

}