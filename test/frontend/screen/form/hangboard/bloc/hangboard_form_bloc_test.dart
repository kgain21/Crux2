import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_bloc.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_event.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_state.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:crux/model/unit.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../../test_util/test_model_factory.dart';
import '../../../dashboard/bloc/dashboard_bloc_test.dart';

void main() {
  BaseWorkoutRepositoryMock baseWorkoutRepositoryMock = BaseWorkoutRepositoryMock();
  HangboardFormBloc hangboardFormBloc;

  setUp(() {
    hangboardFormBloc = HangboardFormBloc(baseWorkoutRepository: baseWorkoutRepositoryMock);
  });

  tearDown(() {
    hangboardFormBloc?.close();
  });

  group('basic checks', () {
    test('initial state is correct', () {
      expect(hangboardFormBloc.initialState, HangboardFormState.initial());
    });

    test('close does not emit new states', () {
      expectLater(
        hangboardFormBloc,
        emitsInOrder([HangboardFormState.initial(), emitsDone]),
      );
      hangboardFormBloc.close();
    });
  });

  group('event handling', () {
    test('emits [initialized, updated state] when user changes resistanceUnit', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(resistanceUnit: ResistanceUnit.POUNDS),
          ]));

      hangboardFormBloc.add(ResistanceUnitChanged(ResistanceUnit.POUNDS));
    });

    test('emits [initialized, updated state] when user changes depthUnit', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(depthUnit: DepthUnit.INCHES),
          ]));

      hangboardFormBloc.add(DepthUnitChanged(DepthUnit.INCHES));
    });

    test('emits [initialized, updated state] when user changes hands', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(hands: 1),
          ]));

      hangboardFormBloc.add(HandsChanged(1));
    });

    group('hold changed tests emit [initialized, updated state]', () {
      test('when user changes hold to POCKET', () {
        var initialHangboardFormState = HangboardFormState.initial();
        var depthChangedState = initialHangboardFormState.copyWith(depth: 1);
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState,
              depthChangedState,
              depthChangedState.copyWith(
                hold: Hold.POCKET,
                showFingerConfiguration: true,
                availableFingerConfigurations: FingerConfiguration.values.sublist(0, 7),
                showDepth: false,
                depth: null,
              ),
            ]));

        hangboardFormBloc.add(DepthChanged(1));
        hangboardFormBloc.add(HoldChanged(Hold.POCKET));
      });

      test('when user changes hold to OPEN_HAND', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState,
              initialHangboardFormState.copyWith(
                hold: Hold.OPEN_HAND,
                showFingerConfiguration: true,
                availableFingerConfigurations: FingerConfiguration.values.sublist(4),
                showDepth: true,
              ),
            ]));

        hangboardFormBloc.add(HoldChanged(Hold.OPEN_HAND));
      });

      test('when user changes hold to FULL_CRIMP', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState,
              initialHangboardFormState.copyWith(
                hold: Hold.FULL_CRIMP,
                showFingerConfiguration: false,
                availableFingerConfigurations: null,
                showDepth: true,
              ),
            ]));

        hangboardFormBloc.add(HoldChanged(Hold.FULL_CRIMP));
      });

      test('when user changes hold to HALF_CRIMP', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState,
              initialHangboardFormState.copyWith(
                hold: Hold.HALF_CRIMP,
                showFingerConfiguration: true,
                availableFingerConfigurations: FingerConfiguration.values.sublist(4),
                showDepth: true,
              ),
            ]));

        hangboardFormBloc.add(HoldChanged(Hold.HALF_CRIMP));
      });

      test('when user changes hold to anything else', () {
        var initialHangboardFormState = HangboardFormState.initial();
        var depthChangedState = initialHangboardFormState.copyWith(depth: 1);
        var fingerConfigurationChangedState =
            depthChangedState.copyWith(fingerConfiguration: FingerConfiguration.INDEX_MIDDLE_RING);

        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState,
              depthChangedState,
              fingerConfigurationChangedState,
              fingerConfigurationChangedState.copyWith(
                hold: Hold.SLOPER,
                showFingerConfiguration: false,
                availableFingerConfigurations: null,
                fingerConfiguration: null,
                showDepth: false,
                depth: null,
              ),
            ]));

        hangboardFormBloc.add(DepthChanged(1));
        hangboardFormBloc.add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING));
        hangboardFormBloc.add(HoldChanged(Hold.SLOPER));
      });
    });

    test('emits [initialized, updated state] when user changes fingerConfiguration', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(
                fingerConfiguration: FingerConfiguration.INDEX_MIDDLE_RING),
          ]));

      hangboardFormBloc.add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING));
    });

    test('emits [initialized, updated state] when user changes depth', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(depth: 1.5),
          ]));

      hangboardFormBloc.add(DepthChanged(1.5));
    });

    test('emits [initialized, updated state] when user changes restDuration', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(restDuration: 3),
          ]));

      hangboardFormBloc.add(RestDurationChanged(3));
    });

    test('emits [initialized, updated state] when user changes repDuration', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(repDuration: 7),
          ]));

      hangboardFormBloc.add(RepDurationChanged(7));
    });

    test('emits [initialized, updated state] when user changes hangsPerSet', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(hangsPerSet: 6),
          ]));

      hangboardFormBloc.add(HangsPerSetChanged(6));
    });

    test('emits [initialized, updated state] when user changes showRestDuration', () {
      var initialHangboardFormState = HangboardFormState.initial();
      var secondState = initialHangboardFormState.copyWith(restDuration: 180);
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            secondState,
            secondState.copyWith(
              showRestDuration: false,
              restDuration: null,
//              hangsPerSet: null,
//              showHangsPerSet: false, -- proposing to only alert user and not forcefully change anything here
            ),
          ]));

      hangboardFormBloc.add(RestDurationChanged(180));
      hangboardFormBloc.add(ShowRestDurationChanged(false));
      //todo: manually turning this off should show an alert that number of hangs must be 1?
      //todo: on toggle: immediately show alert, emit event anyway, update form state, check validation of showRestDuration(false) + hangsPerSet(1) on save?
    });

    test('emits [initialized, updated state] when user changes breakDuration', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(breakDuration: 180),
          ]));

      hangboardFormBloc.add(BreakDurationChanged(180));
    });

    test('emits [initialized, updated state] when user changes numberOfSets', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(numberOfSets: 6),
          ]));

      hangboardFormBloc.add(NumberOfSetsChanged(6));
    });

    test('emits [initialized, updated state] when user changes resistance', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(resistance: 10.5),
          ]));

      hangboardFormBloc.add(ResistanceChanged(10.5));
    });

    /*test('emits [initialized, updated state] when resetFlags event occurs', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(
                isDuplicate: false, isFailure: false, isSuccess: false),
          ]));

      hangboardFormBloc.add(ResetFlags());
    });*/

    test('emits [initialized, updated state] when user saves invalid form', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(autoValidate: true),
          ]));

      hangboardFormBloc.add(InvalidSave());
    });

    group('emits [initialized, updated state] when user saves valid form', () {
      test('when db update occurs successfully, should return state with isSuccess set to true',
          () {
        var cruxUser = TestModelFactory.getTypicalCruxUser();
        var originalCruxWorkout = TestModelFactory.getTypicalCruxWorkout();

        var finalHangboardFormState =
            TestModelFactory.getTypicalOneHandedHangboardWorkoutFormState();
        var expectedUpdatedCruxWorkout = originalCruxWorkout.rebuild((cw) => cw
            .hangboardWorkout.hangboardExercises
            .add(finalHangboardFormState.toHangboardExercise()));

        expectLater(
            hangboardFormBloc,
            emitsThrough(
              finalHangboardFormState,
            ));

        when(baseWorkoutRepositoryMock.updateWorkout(cruxUser, expectedUpdatedCruxWorkout))
            .thenAnswer((_) => Future.value(expectedUpdatedCruxWorkout));

        hangboardFormBloc.add(ResistanceUnitChanged(ResistanceUnit.POUNDS));
        hangboardFormBloc.add(HoldChanged(Hold.HALF_CRIMP));
        hangboardFormBloc
            .add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING_PINKIE));
        hangboardFormBloc.add(HandsChanged(1));
        hangboardFormBloc.add(DepthChanged(14.0));
        hangboardFormBloc.add(RepDurationChanged(10));
        hangboardFormBloc.add(BreakDurationChanged(180));
        hangboardFormBloc.add(ShowRestDurationChanged(false));
        hangboardFormBloc.add(HangsPerSetChanged(1));
        hangboardFormBloc.add(NumberOfSetsChanged(6));
        hangboardFormBloc.add(ResistanceChanged(-25));

        hangboardFormBloc.add(ValidSave(cruxUser: cruxUser, cruxWorkout: originalCruxWorkout));
      });

      test('when state is a duplicate exercise, should return state with isDuplicate set to true',
          () {
        var cruxUser = TestModelFactory.getTypicalCruxUser();
        var originalCruxWorkout = TestModelFactory.getTypicalCruxWorkout();
        var finalHangboardFormState =
            TestModelFactory.getTypicalOneHandedHangboardWorkoutFormState();

        originalCruxWorkout = originalCruxWorkout.rebuild((cw) {
          cw.hangboardWorkout.hangboardExercises.clear();
          cw.hangboardWorkout.hangboardExercises.add(finalHangboardFormState.toHangboardExercise());
        });

        finalHangboardFormState =
            finalHangboardFormState.update(isDuplicate: true, isSuccess: false);

        expectLater(
            hangboardFormBloc,
            emitsThrough(
              finalHangboardFormState,
            ));

        hangboardFormBloc.add(ResistanceUnitChanged(ResistanceUnit.POUNDS));
        hangboardFormBloc.add(HoldChanged(Hold.HALF_CRIMP));
        hangboardFormBloc
            .add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING_PINKIE));
        hangboardFormBloc.add(HandsChanged(1));
        hangboardFormBloc.add(DepthChanged(14.0));
        hangboardFormBloc.add(RepDurationChanged(10));
        hangboardFormBloc.add(BreakDurationChanged(180));
        hangboardFormBloc.add(ShowRestDurationChanged(false));
        hangboardFormBloc.add(HangsPerSetChanged(1));
        hangboardFormBloc.add(NumberOfSetsChanged(6));
        hangboardFormBloc.add(ResistanceChanged(-25));

        hangboardFormBloc.add(ValidSave(cruxUser: cruxUser, cruxWorkout: originalCruxWorkout));
      });

      test('when db call fails and throws exception, should return state with isFailure set to true', () {
        var cruxUser = TestModelFactory.getTypicalCruxUser();
        var originalCruxWorkout = TestModelFactory.getTypicalCruxWorkout();
        var finalHangboardFormState =
            TestModelFactory.getTypicalOneHandedHangboardWorkoutFormState();

        finalHangboardFormState =
            finalHangboardFormState.update(isFailure: true, isSuccess: false);

        when(baseWorkoutRepositoryMock.updateWorkout(cruxUser, any())).thenReturn(null);

        expectLater(
            hangboardFormBloc,
            emitsThrough(
              finalHangboardFormState,
            ));

        hangboardFormBloc.add(ResistanceUnitChanged(ResistanceUnit.POUNDS));
        hangboardFormBloc.add(HoldChanged(Hold.HALF_CRIMP));
        hangboardFormBloc
            .add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING_PINKIE));
        hangboardFormBloc.add(HandsChanged(1));
        hangboardFormBloc.add(DepthChanged(14.0));
        hangboardFormBloc.add(RepDurationChanged(10));
        hangboardFormBloc.add(BreakDurationChanged(180));
        hangboardFormBloc.add(ShowRestDurationChanged(false));
        hangboardFormBloc.add(HangsPerSetChanged(1));
        hangboardFormBloc.add(NumberOfSetsChanged(6));
        hangboardFormBloc.add(ResistanceChanged(-25));

        hangboardFormBloc.add(ValidSave(cruxUser: cruxUser, cruxWorkout: originalCruxWorkout));
      });
    });
  });
}
