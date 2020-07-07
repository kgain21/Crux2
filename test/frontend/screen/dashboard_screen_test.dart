import 'package:bloc_test/bloc_test.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_event.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_state.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
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
      whenListen(
        dashboardBlockMock,
        Stream.fromIterable([
          DashboardUninitialized(),
        ]),
      );
      await tester.pumpWidget(subject);

      dartTest.expect(findScaffold, findsOneWidget);
    });
  });

  group('Calendar interaction tests', () {
    var selectedDate = DateTime.now();
    var currentDay = selectedDate.day;

    testWidgets('Test calendar date tapped interaction adds a CalendarDateChanged event',
        (WidgetTester tester) async {
      whenListen(
        dashboardBlockMock,
        Stream.fromIterable([
          DashboardUninitialized(),
        ]),
      );

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

  group('State update interaction tests', () {
    var selectedDate = DateTime.now();

    testWidgets('Test build with DashboardDateChangedSuccess state', (WidgetTester tester) async {
      whenListen(
        dashboardBlockMock,
        Stream.fromIterable([
          DashboardUninitialized(),
          DashboardDateChangeInProgress(),
          DashboardDateChangeSuccess(selectedDate: selectedDate, cruxWorkout: CruxWorkout()),
        ]),
      );

      await tester.pumpWidget(subject);

      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets(
        'Test build with DashboardDateChangeNotFound state given past date should show '
        'noWorkoutFoundDialog with working Cancel button', (WidgetTester tester) async {
      whenListen(
        dashboardBlockMock,
        Stream.fromIterable([
          DashboardUninitialized(),
          DashboardDateChangeInProgress(),
          DashboardDateChangeNotFound(selectedDate: selectedDate.subtract(Duration(days: 2))),
        ]),
      );

      await tester.pumpWidget(subject);
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.byKey(Key('noWorkoutFoundDialog')), findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'Create New Workout'), findsNothing);

      var cancelButton = find.widgetWithText(FlatButton, 'Cancel');
      expect(cancelButton, findsOneWidget);

      await tester.tap(cancelButton);
      expect(find.byKey(Key('noWorkoutFoundDialogCreateNew')), findsNothing);
    });

    testWidgets(
        'Test build with DashboardDateChangeNotFound state given future date should show '
        'noWorkoutFoundDialogCreateNew', (WidgetTester tester) async {
      var futureSelectedDate = selectedDate.add(Duration(days: 2));

      whenListen(
        dashboardBlockMock,
        Stream.fromIterable([
          DashboardUninitialized(),
          DashboardDateChangeInProgress(),
          DashboardDateChangeNotFound(selectedDate: futureSelectedDate),
        ]),
      );

      await tester.pumpWidget(subject);
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.byKey(Key('noWorkoutFoundDialogCreateNew')), findsOneWidget);
      var newWorkoutButton = find.widgetWithText(FlatButton, 'Create New Workout');
      expect(newWorkoutButton, findsOneWidget);

      await tester.tap(newWorkoutButton);

      var result = verify(dashboardBlockMock.add(captureThat(isA<CreateNewWorkoutButtonTapped>())));
      result.called(1);
      expect((result.captured.first as CreateNewWorkoutButtonTapped).cruxUser, cruxUser);
      expect((result.captured.first as CreateNewWorkoutButtonTapped).selectedDate.day, futureSelectedDate.day);
    });
  });
}

