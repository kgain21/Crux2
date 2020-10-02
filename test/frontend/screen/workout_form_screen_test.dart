import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/frontend/screen/form/hangboard_form_screen.dart';
import 'package:crux/frontend/screen/form/workout_form_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/widget_test_utils.dart';

void main() {
  var subject;

  NavigatorObserverMock navigatorObserverMock;

  final CruxUser cruxUser = CruxUser(displayName: 'Display Name', email: 'Email');

  setUp(() {
    navigatorObserverMock = NavigatorObserverMock();

    subject = buildTestableWidget(WorkoutFormScreen(cruxUser: cruxUser, selectedDate: DateTime.now()),
        navigatorObserverMock: navigatorObserverMock);
  });

  group('WorkoutFormScreen structural tests', () {
    testWidgets('test WorkoutFormScreen builds correctly', (WidgetTester tester) async {
      final findScaffold = find.byKey(Key('workoutFormScaffold'));
      await tester.pumpWidget(subject);

      expect(findScaffold, findsOneWidget);
    });
  });

  group('WorkoutFormScreen navigation tests', () {
    testWidgets(
        'Hangboard tile onClick should navigate to hangboard screen', (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      final findHangboardTile = find.byKey(Key('hangboardFormTile'));
      await tester.tap(findHangboardTile);
      await tester.pumpAndSettle();

      final Route pushedRoute = verify(navigatorObserverMock.didPush(captureAny, any))
          .captured
          .where((element) => element.settings.name == HangboardFormScreen.routeName)
          .first;

      expect(pushedRoute, isNotNull);
    });
  });
}
