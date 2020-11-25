import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'hangboard_exercise.g.dart';

abstract class HangboardExercise implements Built<HangboardExercise, HangboardExerciseBuilder> {
  HangboardExercise._();

  factory HangboardExercise([updates(HangboardExerciseBuilder b)]) = _$HangboardExercise;

  static Serializer<HangboardExercise> get serializer => _$hangboardExerciseSerializer;

  String get exerciseTitle;

  String get depthUnit;

  String get resistanceUnit;

  int get hands;

  String get hangProtocol;

  String get hold;

  @nullable
  String get fingerConfiguration;

  @nullable
  double get depth;

  @nullable
  int get restDuration;

  int get repDuration;

  int get breakDuration;

  int get hangsPerSet;

  int get numberOfSets;

  @nullable
  double get resistance;
}
