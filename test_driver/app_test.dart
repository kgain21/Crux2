import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter app', () {

    /// 'Finders' are defined to locate the widgets under test by their keys
    final counterTextFinder = find.byValueKey('counter');
    final buttonFinder = find.byValueKey('increment');

    FlutterDriver flutterDriver;

    setUpAll(() async {
      flutterDriver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if(flutterDriver != null) {
        flutterDriver.close();
      }
    });

    /// Make sure text is at 0 initially
    test('starts at 0', () async {
      expect(await flutterDriver.getText(counterTextFinder), '0');
    });

    /// Find button, tap it, expect text to be 1
    test('starts at 0', () async {
      await flutterDriver.tap(buttonFinder);

      expect(await flutterDriver.getText(counterTextFinder), '1');
    });
  });
}

/// TO RUN:
/// flutter drive --target=test_driver/app.dart
/// NOTE**
/// Widgets need keys to be identified by the finders - get in the habit of using them