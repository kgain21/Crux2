import 'package:crux/backend/bloc/dashboard/dashboard_bloc.dart';
import 'package:crux/backend/bloc/dashboard/dashboard_state.dart';
import 'package:crux/backend/repository/workout/workout_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class BaseWorkoutRepositoryMock extends Mock implements BaseWorkoutRepository {}

void main() {
  var baseWorkoutRepositoryMock = BaseWorkoutRepositoryMock();
  DashboardBloc dashboardBloc;

  setUp(() {
    dashboardBloc = DashboardBloc(workoutRepository: baseWorkoutRepositoryMock);
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
    }, skip: true);
  });
}
