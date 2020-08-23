import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/frontend/screen/workout_form_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_util/widget_test_utils.dart';

void main() {
  var subject;

  NavigatorObserverMock navigatorObserverMock;

  final CruxUser cruxUser = CruxUser(displayName: 'Display Name', email: 'Email');

  setUp(() {
    navigatorObserverMock = NavigatorObserverMock();

    subject = buildTestableWidget(WorkoutFormScreen(cruxUser, DateTime.now()),
        navigatorObserverMock: navigatorObserverMock);
  });

  group('WorkoutFormScreen structural tests', () {
    testWidgets('test WorkoutFormScreen builds correctly', (WidgetTester tester) async {
      final findScaffold = find.byKey(Key('workoutFormScaffold'));
      await tester.pumpWidget(subject);

      expect(findScaffold, findsOneWidget);
    });
  });
}
