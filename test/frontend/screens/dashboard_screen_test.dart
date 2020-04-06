import 'package:crux/frontend/screens/dashboard_screen.dart';
import 'package:crux/backend/blocs/user/models/crux_user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as dartTest;

import '../../test_utils/widget_test_utils.dart';


class ModalRouteMock extends Mock implements ModalRoute {}

void main() {
  var subject;

  var navigatorObserverMock = NavigatorObserverMock();
  final CruxUser cruxUser = CruxUser(displayName: 'Display Name', email: 'Email');

  dartTest.setUp(() {
    subject = buildTestableWidget(DashboardScreen(cruxUser: cruxUser), navigatorObserverMock: navigatorObserverMock);
  });

  group('Dashboard screen structural tests', () {
    final findScaffold = find.byKey(Key('dashboardScaffold'));

    testWidgets('test Dashboard screen builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      dartTest.expect(findScaffold, findsOneWidget);
    });
  });
}
