import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_test/flutter_test.dart' as flutterTest;
import 'package:test/test.dart';

void main() {
  group('Sign In Screen tests', () {
    FlutterDriver flutterDriver;

    final googleSignInButtonFinder = find.byValueKey('signInGoogleButton');

    setUpAll(() async {
      flutterDriver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (flutterDriver != null) {
        flutterDriver.close();
      }
    });

    test('Sign in with google', () async {
      await flutterDriver.tap(googleSignInButtonFinder);

      expect(find.byType('DashboardScreen'), flutterTest.findsOneWidget);
    });
  });
}
