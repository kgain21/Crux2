import 'package:crux/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

void main() {
  /// Creates a separate 'instrumented' version of the app to record performance
  /// profiles.
  enableFlutterDriverExtension();
  app.main();
}
