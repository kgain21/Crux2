import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campus_board_type_enum.g.dart';
class CampusBoardTypeEnum extends EnumClass {

  const CampusBoardTypeEnum._(String name) : super(name);

  static BuiltSet<CampusBoardTypeEnum> get values => _$values;
  static CampusBoardTypeEnum valueOf(String name) => _$valueOf(name);

  static Serializer<CampusBoardTypeEnum> get serializer => _$campusBoardTypeEnumSerializer;

  static const CampusBoardTypeEnum ladder = _$ladder;
  static const CampusBoardTypeEnum touches = _$touches;
  static const CampusBoardTypeEnum crossovers = _$crossovers;
  static const CampusBoardTypeEnum bumps = _$bumps;
  static const CampusBoardTypeEnum jumpAndCatch = _$jumpAndCatch;
  static const CampusBoardTypeEnum doubles = _$doubles;
}