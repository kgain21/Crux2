import 'package:crux/backend/bloc/hangboard/form/hangboard_form_bloc.dart';
import 'package:crux/backend/bloc/hangboard/form/hangboard_form_state.dart';
import 'package:test/test.dart';

void main() {
  HangboardFormBloc hangboardFormBloc;

  setUp(() {
    hangboardFormBloc = HangboardFormBloc();
  });

  tearDown(() {
    hangboardFormBloc?.close();
  });

  group('basic checks', () {
    test('initial state is correct', () {
      expect(hangboardFormBloc.initialState, HangboardFormUninitialized());
    });

    test('close does not emit new states', () {
      expectLater(
        hangboardFormBloc,
        emitsInOrder([HangboardFormUninitialized(), emitsDone]),
      );
      hangboardFormBloc.close();
    });
  });

  group('event handling', () {
    /*group('CalendarDateChanged', () {
      var selectedDate = DateTime(2020);
      var testUser = TestModelFactory.getTypicalCruxUser();
      var testWorkout = TestModelFactory.getTypicalCruxWorkout();

      test('emits [uninitialized, dateChangeInProgress, dateChangeSuccess] given valid cruxUser and'
          ' selectedDate', () {
        expectLater(
            dashboardBloc,
            emitsInOrder([
              DashboardUninitialized(),
//              DashboardInitialized(), todo: may still want this, not sure yet
              DashboardDateChangeInProgress(),
              DashboardDateChangeSuccess(selectedDate: selectedDate, cruxWorkout: testWorkout),
            ]));

        when(baseWorkoutRepositoryMock.findWorkoutByDate(selectedDate, testUser))
            .thenAnswer((_) => Future.value(testWorkout));
        dashboardBloc.add(CalendarDateChanged(selectedDate: selectedDate, cruxUser: testUser));
      });

      test('emits [uninitialized, dateChangeInProgress, dateChangeError] given valid cruxUser and'
          ' selectedDate when error occurs querying db', () {
        expectLater(
            dashboardBloc,
            emitsInOrder([
              DashboardUninitialized(),
//              DashboardInitialized(), todo: may still want this, not sure yet
              DashboardDateChangeInProgress(),
              DashboardDateChangeError(selectedDate: selectedDate),
            ]));

        when(baseWorkoutRepositoryMock.findWorkoutByDate(selectedDate, testUser))
            .thenAnswer((_) => Future.error(Exception('Dashboard date changed test')));
        dashboardBloc.add(CalendarDateChanged(selectedDate: selectedDate, cruxUser: testUser));
      });

      test('emits [uninitialized, dateChangeInProgress, dateChangeNotFound] given valid cruxUser'
          ' and selectedDate when no workout found in db', () {
        expectLater(
            dashboardBloc,
            emitsInOrder([
              DashboardUninitialized(),
//              DashboardInitialized(), todo: may still want this, not sure yet
              DashboardDateChangeInProgress(),
              DashboardDateChangeNotFound(selectedDate: selectedDate),
            ]));

        when(baseWorkoutRepositoryMock.findWorkoutByDate(selectedDate, testUser))
            .thenAnswer((_) => Future.value(null));
        dashboardBloc.add(CalendarDateChanged(selectedDate: selectedDate, cruxUser: testUser));
      });
    });*/
  });
}
