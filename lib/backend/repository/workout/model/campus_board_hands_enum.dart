import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campus_board_hands_enum.g.dart';

class CampusBoardHandsEnum extends EnumClass {
  static Serializer<CampusBoardHandsEnum> get serializer => _$campusBoardHandsEnumSerializer;

  const CampusBoardHandsEnum._(String name) : super(name);

  static BuiltSet<CampusBoardHandsEnum> get values => _$values;

  static CampusBoardHandsEnum valueOf(String name) => _$valueOf(name);
  static const CampusBoardHandsEnum left = _$left;
  static const CampusBoardHandsEnum right = _$right;
  static const CampusBoardHandsEnum both = _$both;
}
