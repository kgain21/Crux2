import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crux/backend/repository/workout/model/campus_board_hands_enum.dart';
import 'package:crux/backend/repository/workout/model/campus_board_type_enum.dart';

part 'campus_board_exercise.g.dart';

abstract class CampusBoardExercise
    implements Built<CampusBoardExercise, CampusBoardExerciseBuilder> {
  CampusBoardExercise._();

  factory CampusBoardExercise([updates(CampusBoardExerciseBuilder b)]) = _$CampusBoardExercise;

  static Serializer<CampusBoardExercise> get serializer => _$campusBoardExerciseSerializer;

  List<int> get sequence;

  CampusBoardTypeEnum get type;

  CampusBoardHandsEnum get hands;

  int get startingRung;

  int get restDuration;
}
