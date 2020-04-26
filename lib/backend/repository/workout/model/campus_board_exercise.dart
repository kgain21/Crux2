import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campus_board_exercise.g.dart';
part 'campus_board_exercise_enum.g.dart';
part 'campus_board_hands_enum.g.dart';
abstract class CampusBoardExercise implements Built<CampusBoardExercise, CampusBoardExerciseBuilder> {
  CampusBoardExercise._();

  factory CampusBoardExercise([updates(CampusBoardExerciseBuilder b)]) = _$CampusBoardExercise;

  static Serializer<CampusBoardExercise> get = $_campusBoardExerciseSerializer
  
  List<int> get sequence;

  CampusBoardTypeEnum get type;
  
  CampusBoardHandsEnum get hands;

  int get startingRung;

  int get restDuration;
}

class CampusBoardTypeEnum extends EnumClass {

  const CampusBoardTypeEnum._(String name) : super(name);

  static BuiltSet<CampusBoardTypeEnum> get values => _$values;
  static CampusBoardTypeEnum valueOf(String name) => _$valueOf(name);

  static Serializer<CampusBoardTypeEnum> get serializer => $_campusBoardTypeEnumSerializer;

  static const CampusBoardTypeEnum ladder = $_ladder;
  static const CampusBoardTypeEnum touches = $_touches;
  static const CampusBoardTypeEnum crossovers = $_crossovers;
  static const CampusBoardTypeEnum bumps = $_bumps;
  static const CampusBoardTypeEnum jumpAndCatch = $_jumpAndCatch;
  static const CampusBoardTypeEnum doubles = $_doubles;
}

/*
class CampusBoardHandsEnum extends EnumClass {
  static Serializer<CampusBoardHandsEnum> get serializer => $_campusBoardHandsEnumSerializer;

  static const CampusBoardHandsEnum left = $_left;
  static const CampusBoardHandsEnum right = $_right;
  static const CampusBoardHandsEnum both = $_both;

}*/
