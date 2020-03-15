import 'package:crux/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();

  app.main();
}

/// TO RUN:
/// flutter drive --target=test_driver/sign_in_screen.dart
/// *NOTE -- need one file with main() and another file with same name ending in _test.dart