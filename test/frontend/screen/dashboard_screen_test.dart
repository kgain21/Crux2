import 'package:crux/backend/bloc/dashboard/dashboard_bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_event.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/frontend/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test/test.dart' as dartTest;

import '../../test_util/widget_test_utils.dart';

class ModalRouteMock extends Mock implements ModalRoute {}

class DashboardBlocMock extends Mock implements DashboardBloc {}

void main() {
  var subject;

  var navigatorObserverMock = NavigatorObserverMock();
  var dashboardBlockMock = DashboardBlocMock();

  final CruxUser cruxUser = CruxUser(displayName: 'Display Name', email: 'Email');

  dartTest.setUp(() {
    subject = buildTestableWidget(
        DashboardScreen(
          cruxUser: cruxUser,
          dashboardBloc: dashboardBlockMock,
        ),
        navigatorObserverMock: navigatorObserverMock);
  });

  dartTest.tearDown(() => dashboardBlockMock.close());

  group('Dashboard screen structural tests', () {
    final findScaffold = find.byKey(Key('dashboardScaffold'));

    testWidgets('test Dashboard screen builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      dartTest.expect(findScaffold, findsOneWidget);
    });
  });

  group('Calendar Tests', () {
    var selectedDate = DateTime.now();
    var currentDay = selectedDate.day;

    testWidgets('Test new calendar date tapped interaction with DashboardDateChangedSuccess state',
        (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      // Scroll down 200px in case date is cut off by smaller screen
      var tableCalendar = find.byType(TableCalendar);
      await tester.drag(tableCalendar, Offset(0.0, -200));
      await tester.pump();

      // Get the calendar day corresponding with today and find its center to tap it
      var calendarDayCenter =
          tester.getCenter(find.widgetWithText(ConstrainedBox, currentDay.toString()));
      await tester.tapAt(Offset(calendarDayCenter.dx, calendarDayCenter.dy));

      // Capture the call to the mock here and assert on it
      var result = verify(dashboardBlockMock.add(captureThat(isA<CalendarDateChanged>())));
      result.called(1);
      expect((result.captured.first as CalendarDateChanged).cruxUser, cruxUser);
      expect((result.captured.first as CalendarDateChanged).selectedDate.day, selectedDate.day);
    });
  });
}
