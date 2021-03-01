import 'package:crux/model/hangboard/finger_configuration.dart';
import 'package:crux/model/hangboard/hang_protocol.dart';
import 'package:crux/model/hangboard/hold.dart';
import 'package:crux/model/hangboard/unit.dart';
import 'package:crux/util/string_format_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('createHangboardExerciseTitle tests', () {
    test('given null hold, should throw assertion error', () {
      expect(() => StringFormatUtil.createHangboardExerciseTitle(hold: null, hands: 2),
          throwsAssertionError);
    });

    test('given null hands, should throw assertion error', () {
      expect(() => StringFormatUtil.createHangboardExerciseTitle(hold: Hold.JUGS, hands: null),
          throwsAssertionError);
    });

    test('given basic required inputs, should create minimal exercise title', () {
      String exerciseTitle =
          StringFormatUtil.createHangboardExerciseTitle(hold: Hold.JUGS, hands: 2);
      assert(exerciseTitle == "Two-Handed Jugs");
    });

    test('given fingerConfiguration and required inputs, should create correct exercise title', () {
      String exerciseTitle = StringFormatUtil.createHangboardExerciseTitle(
        hold: Hold.OPEN_HAND,
        hands: 2,
        fingerConfiguration: FingerConfiguration.INDEX_MIDDLE_RING,
      );
      assert(exerciseTitle == "Two-Handed I/M/R Open Hand");
    });

    test('given hangProtocol of NONE, and required inputs, should create correct exercise title',
        () {
      String exerciseTitle = StringFormatUtil.createHangboardExerciseTitle(
        hold: Hold.JUGS,
        hands: 2,
        hangProtocol: HangProtocol.NONE,
      );
      assert(exerciseTitle == "Two-Handed Jugs");
    });

    test('given depth, depthUnit, and required inputs, should create correct exercise title', () {
      String exerciseTitle = StringFormatUtil.createHangboardExerciseTitle(
          hold: Hold.FULL_CRIMP, hands: 2, depth: 10, depthUnit: DepthUnit.MILLIMETERS);
      assert(exerciseTitle == "Two-Handed 10mm Full Crimp");
    });

    test('given all fields, should create correct exercise title', () {
      String exerciseTitle = StringFormatUtil.createHangboardExerciseTitle(
        hold: Hold.HALF_CRIMP,
        hands: 1,
        depth: 1.5,
        fingerConfiguration: FingerConfiguration.INDEX_MIDDLE_RING_PINKIE,
        depthUnit: DepthUnit.INCHES,
        hangProtocol: HangProtocol.MAX_HANGS,
      );
      assert(exerciseTitle == "One-Handed 1.5in I/M/R/P Half Crimp Max Hangs");
    });
  });
}
