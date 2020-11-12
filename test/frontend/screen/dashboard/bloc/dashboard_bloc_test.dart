import 'package:crux/backend/repository/workout/base_workout_repository.dart';
import 'package:crux/frontend/screen/dashboard/bloc/dashboard_bloc.dart';
import 'package:crux/frontend/screen/dashboard/bloc/dashboard_event.dart';
import 'package:crux/frontend/screen/dashboard/bloc/dashboard_state.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_util/test_model_factory.dart';

class BaseWorkoutRepositoryMock extends Mock implements BaseWorkoutRepository {}

void main() {
  BaseWorkoutRepositoryMock baseWorkoutRepositoryMock;
  DashboardBloc dashboardBloc;

  setUp(() {
    baseWorkoutRepositoryMock = BaseWorkoutRepositoryMock();
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
      var selectedDate = DateTime(2020);
      var testUser = TestModelFactory.getTypicalCruxUser();
      var testWorkout = TestModelFactory.getTypicalCruxWorkout();

      test(
          'emits [uninitialized, dateChangeInProgress, dateChangeSuccess] given valid cruxUser and'
          ' selectedDate', () {
        expectLater(
            dashboardBloc,
            emitsInOrder([
              DashboardUninitialized(),
              DashboardDateChangeInProgress(),
              DashboardDateChangeSuccess(selectedDate: selectedDate, cruxWorkout: testWorkout),
            ]));

        when(baseWorkoutRepositoryMock.findWorkoutByDate(selectedDate, testUser))
            .thenAnswer((_) => Future.value(testWorkout));
        dashboardBloc.add(CalendarDateChanged(selectedDate: selectedDate, cruxUser: testUser));
      });

      test(
          'emits [uninitialized, dateChangeInProgress, dateChangeError] given valid cruxUser and'
          ' selectedDate when error occurs querying db', () {
        expectLater(
            dashboardBloc,
            emitsInOrder([
              DashboardUninitialized(),
              DashboardDateChangeInProgress(),
              DashboardDateChangeError(selectedDate: selectedDate),
            ]));

        when(baseWorkoutRepositoryMock.findWorkoutByDate(selectedDate, testUser))
            .thenAnswer((_) => Future.error(Exception('Dashboard date changed test')));
        dashboardBloc.add(CalendarDateChanged(selectedDate: selectedDate, cruxUser: testUser));
      });

      test(
          'emits [uninitialized, dateChangeInProgress, dateChangeNotFound] given valid cruxUser'
          ' and selectedDate when no workout found in db', () {
        expectLater(
            dashboardBloc,
            emitsInOrder([
              DashboardUninitialized(),
              DashboardDateChangeInProgress(),
              DashboardDateChangeNotFound(selectedDate: selectedDate),
            ]));

        when(baseWorkoutRepositoryMock.findWorkoutByDate(selectedDate, testUser))
            .thenAnswer((_) => Future.value(null));
        dashboardBloc.add(CalendarDateChanged(selectedDate: selectedDate, cruxUser: testUser));
      });
    });
  });
}
