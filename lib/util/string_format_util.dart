// TODO: Recommended to not use static method only classes --
// https://dart.dev/guides/language/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members
// TODO: Refactor at some point

import 'package:crux/model/hangboard/finger_configuration.dart';
import 'package:crux/model/hangboard/hang_protocol.dart';
import 'package:crux/model/hangboard/hold.dart';
import 'package:crux/model/hangboard/unit.dart';
import 'package:flutter/foundation.dart';

class StringFormatUtil {
  static String formatDepthAndHold(
      double depth, String depthMeasurementSystem, String fingerConfiguration, String hold) {
    if (depth == null || depth == 0) {
      if (fingerConfiguration == null || fingerConfiguration == '') {
        return hold;
      }
      return '$fingerConfiguration $hold';
    } else {
      if (fingerConfiguration == null || fingerConfiguration == '') {
        return '${formatDecimals(depth)}$depthMeasurementSystem $hold';
      }
      return '${formatDecimals(depth)}$depthMeasurementSystem $fingerConfiguration $hold';
    }
  }

  /// Formatter for displaying the number of hangs left in an exercise with resistance included.
  /// Number of hangs will be displayed in a separate widget on screen so will not be included in
  /// this string.
  //todo: resistance should be a double - rework this to include truncation + value/unit combination
  //todo: in the same way that depth/depthUnit is done below. Could also apply to method above^
  static formatHangsAndResistance(int hangs, int resistance, String resistanceMeasurementSystem) {
    if (hangs == null || hangs == 1) {
      if (resistance == null || resistance == 0) {
        return ' Hang At Body Weight';
      } else {
        return ' Hang With $resistance$resistanceMeasurementSystem';
      }
    } else {
      if (resistance == null || resistance == 0) {
        return ' Hangs At Body Weight';
      }
      return ' Hangs With $resistance$resistanceMeasurementSystem';
    }
  }

  static String formatDecimals(double decimal) {
    if (decimal == 1.75) return '1 3/4';
    if (decimal == 1.5) return '1 1/2';
    if (decimal == 1.25) return '1 1/4';
    if (decimal == 0.875) return '7/8';
    if (decimal == 0.75) return '3/4';
    if (decimal == 0.625) return '5/8';
    if (decimal == 0.5) return '1/2';
    if (decimal == 0.375) return '3/8';
    if (decimal == 0.25) return '1/4';
    if (decimal == 0.125) return '1/8';
    var decimalString = decimal.toString().split('.');
    if (decimalString[1] == '0') return int.tryParse(decimalString[0]).toString();
    return decimal.toString();
  }

  /// Formatter for hangboard exercise titles. Joins any provided elements to a title string, with
  /// special handling for depth in the format of depth and unit next to each other if present.
  /// If both depth and depthUnit are not present, no value will be mapped.
  static String createHangboardExerciseTitle({
    @required Hold hold,
    @required int hands,
    FingerConfiguration fingerConfiguration,
    double depth,
    DepthUnit depthUnit,
    HangProtocol hangProtocol,
  }) {
    assert(hold != null, "Value for Hold must be present");
    assert(hands != null, "Value for Hands must be present");

    var handsString;
    if (hands == 1)
      handsString = 'One';
    else
      handsString = 'Two';

    // formatting for depth/depthUnit i.e. '12mm' instead of '12.0 mm'
    var depthString;
    if (depth != null && depthUnit != null) {
      depthString = depth.toString();
      if (depth.floor() == depth) {
        depthString = depth?.truncate().toString();
      }
      depthString += depthUnit.abbreviation;
    }

    List<String> titleElements = [
      '$handsString-Handed',
      depthString,
      fingerConfiguration.abbreviation,
      hold.name,
      hangProtocol == HangProtocol.NONE ? null : hangProtocol.name,
    ];

    return titleElements.where((e) => e != null).join(" ");
  }
}
