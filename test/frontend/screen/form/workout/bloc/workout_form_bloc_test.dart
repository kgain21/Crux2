import 'package:crux/frontend/screen/form/workout/bloc/workout_form_bloc.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_event.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../test_util/test_model_factory.dart';
import '../../../dashboard/bloc/dashboard_bloc_test.dart';

void main() {
  BaseWorkoutRepositoryMock baseWorkoutRepositoryMock;
  WorkoutFormBloc workoutFormBloc;

  setUp(() {
    baseWorkoutRepositoryMock = BaseWorkoutRepositoryMock();
    workoutFormBloc = WorkoutFormBloc(workoutRepository: baseWorkoutRepositoryMock);
  });

  tearDown(() {
    workoutFormBloc?.close();
  });

  group('basic checks', () {
    test('initial state is correct', () {
      expect(workoutFormBloc.state, WorkoutFormUninitialized());
    });

    test('close does not emit new states', () {
      expectLater(
        workoutFormBloc,
        emitsInOrder([emitsDone]),
      );
      workoutFormBloc.close();
    });
  });

  group('event handling', () {
    group('WorkoutFormInitialized', () {
      var workoutDate = DateTime(2020);
      var testUser = TestModelFactory.getTypicalCruxUser();
      var testWorkout = TestModelFactory.getTypicalCruxWorkout();

      test('emits [initializationSuccess] given valid cruxUser and workoutDate', () {
        expectLater(
            workoutFormBloc,
            emitsInOrder([
              WorkoutFormInitializationInProgress(),
              WorkoutFormInitializationSuccess(cruxWorkout: testWorkout),
            ]));

        when(baseWorkoutRepositoryMock.findWorkoutByDate(workoutDate, testUser))
            .thenAnswer((_) => Future.value(testWorkout));

        workoutFormBloc.add(WorkoutFormInitialized(cruxUser: testUser, workoutDate: workoutDate));
      });

      test(
          'emits [initializationInProgress, initializationFailure] given valid cruxUser and'
              ' workoutDate when error occurs querying db', () {
        expectLater(
            workoutFormBloc,
            emitsInOrder([
              WorkoutFormInitializationInProgress(),
              WorkoutFormInitializationError(),
            ]));

        when(baseWorkoutRepositoryMock.findWorkoutByDate(workoutDate, testUser))
            .thenAnswer((_) => Future.error(Exception('Workout form initialization test')));

        workoutFormBloc.add(WorkoutFormInitialized(workoutDate: workoutDate, cruxUser: testUser));
      });
    });
  });
}
