import 'package:crux/backend/bloc/dashboard/dashboard_bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_state.dart';
import 'package:test/test.dart';

void main() {
  DashboardBloc dashboardBloc;

  setUp(() {
    dashboardBloc = DashboardBloc();
  });

  tearDown(() {
    dashboardBloc?.close();
  });

  group('basic checks', () {
    test('initial state is correct', () {
      expect(dashboardBloc.initialState, DashboardUninitialized());
    });

    test('close does not emit new states', () {
      expectLater(
        dashboardBloc,
        emitsInOrder([DashboardUninitialized(), emitsDone]),
      );
      dashboardBloc.close();
    });
  });

  group('event handling', () {
    group('CalendarDateChanged', () {
      test('yields new state with selectedDate', () {
        expectLater(dashboardBloc, emitsInOrder([DashboardUninitialized(), DashboardInitialized()]));

      });
    });
  });
}
