import 'package:crux/frontend/screens/dashboard_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as dartTest;

import '../../backend/blocs/authentication/authentication_bloc_test.dart';
import '../../test_utils/widget_test_utils.dart';

class ModalRouteMock extends Mock implements ModalRoute {}

void main() {
  DashboardScreen subject;

  CruxUserMock cruxUserMock;
  ModalRouteMock modalRouteMock;
  var navigatorObserverMock = NavigatorObserverMock();

  dartTest.setUp(() {
    subject = buildTestableWidget(DashboardScreen(), navigatorObserverMock: navigatorObserverMock);
    cruxUserMock = CruxUserMock();
    modalRouteMock = ModalRouteMock();
//    when(navigatorObserverMock.navigator)
  });

//  when(modalRouteMock.settings).
//  when(cruxUserMock.displayName).thenReturn('Display Name');

  group('Dashboard screen structural tests', () {
    final findScaffold = find.byKey(Key('dashboardScaffold'));

    testWidgets('test Dashboard screen builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      dartTest.expect(findScaffold, findsOneWidget);
    });
  });
}
