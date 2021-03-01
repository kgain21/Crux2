import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_bloc.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_event.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_state.dart';
import 'package:crux/model/hangboard/finger_configuration.dart';
import 'package:crux/model/hangboard/hang_protocol.dart';
import 'package:crux/model/hangboard/hold.dart';
import 'package:crux/model/hangboard/unit.dart';
import 'package:crux/util/null_util.dart';
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
      expect(hangboardFormBloc.state, HangboardFormState.initial());
    });

    test('close does not emit new states', () {
      expectLater(
        hangboardFormBloc,
        emitsInOrder([emitsDone]),
      );
      hangboardFormBloc.close();
    });
  });

  group('event handling', () {
    group('UnitChanged Tests', () {
      test('when user changes resistanceUnit, should yield state with updated resistanceUnit', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(resistanceUnit: ResistanceUnit.POUNDS),
            ]));

        hangboardFormBloc.add(ResistanceUnitChanged(ResistanceUnit.POUNDS));
      });

      test('when user changes depthUnit, should yield state with updated depthUnit', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(depthUnit: DepthUnit.INCHES),
            ]));

        hangboardFormBloc.add(DepthUnitChanged(DepthUnit.INCHES));
      });
    });

    group('HandsChanged Tests', () {
      test('when user changes hands, should yield state with updated hands', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(hands: 1),
            ]));

        hangboardFormBloc.add(HandsChanged(1));
      });
    });

    group('HangProtocolChanged Tests', () {
      test('when user changes hangProtocol, should yield state with updated hangProtocol', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(hangProtocol: HangProtocol.MAX_HANGS),
            ]));

        hangboardFormBloc.add(HangProtocolChanged(HangProtocol.MAX_HANGS));
      });
    });

    group('HoldChanged tests', () {
      test('when user changes hold to POCKET', () async {
        var holdSelectedChangedState = HangboardFormState.initial().update(
          hold: Hold.HALF_CRIMP,
          showFingerConfiguration: true,
          showDepth: true,
          availableFingerConfigurations: Nullable(FingerConfiguration.values.sublist(4)),
        );
        var fingerConfigurationChangedState = holdSelectedChangedState.update(
            fingerConfiguration: Nullable(FingerConfiguration.INDEX_MIDDLE_RING_PINKIE));
        var depthChangedState = fingerConfigurationChangedState.update(depth: Nullable(1));

        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              holdSelectedChangedState,
              fingerConfigurationChangedState,
              depthChangedState,
              depthChangedState.update(
                hold: Hold.POCKET,
                showFingerConfiguration: true,
                availableFingerConfigurations: Nullable(FingerConfiguration.values.sublist(0, 7)),
                fingerConfiguration: Nullable(null),
                showDepth: false,
                depth: Nullable(null),
              ),
            ]));

        hangboardFormBloc.add(HoldChanged(Hold.HALF_CRIMP));
        hangboardFormBloc
            .add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING_PINKIE));
        hangboardFormBloc.add(DepthChanged(1));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(HoldChanged(Hold.POCKET));
      });

      test('when user changes hold to OPEN_HAND', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(
                hold: Hold.OPEN_HAND,
                showFingerConfiguration: true,
                availableFingerConfigurations: Nullable(FingerConfiguration.values.sublist(4)),
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
              initialHangboardFormState.update(
                hold: Hold.FULL_CRIMP,
                showFingerConfiguration: false,
                availableFingerConfigurations: Nullable(null),
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
              initialHangboardFormState.update(
                hold: Hold.HALF_CRIMP,
                showFingerConfiguration: true,
                availableFingerConfigurations: Nullable(FingerConfiguration.values.sublist(4)),
                showDepth: true,
              ),
            ]));

        hangboardFormBloc.add(HoldChanged(Hold.HALF_CRIMP));
      });

      test(
          'should wipe out depth, fingerConfiguration, and hide those fields when user changes hold to anything else',
          () async {
        var depthChangedState = HangboardFormState.initial().update(depth: Nullable(1));
        var fingerConfigurationChangedState = depthChangedState.update(
            fingerConfiguration: Nullable(FingerConfiguration.INDEX_MIDDLE_RING));

        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              depthChangedState,
              fingerConfigurationChangedState,
              fingerConfigurationChangedState.update(
                hold: Hold.SLOPER,
                showFingerConfiguration: false,
                availableFingerConfigurations: Nullable(null),
                fingerConfiguration: Nullable(null),
                showDepth: false,
                depth: Nullable(null),
              ),
            ]));

        hangboardFormBloc.add(DepthChanged(1));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING));
        hangboardFormBloc.add(HoldChanged(Hold.SLOPER));
      });
    });

    group('FingerConfigurationChanged Tests', () {
      test('emits [initialized, updated state] when user changes fingerConfiguration', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(
                  fingerConfiguration: Nullable(FingerConfiguration.INDEX_MIDDLE_RING)),
            ]));

        hangboardFormBloc.add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING));
      });
    });

    group('DepthChanged Tests', () {
      test('when user changes depth, should yield state with updated depth', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(depth: Nullable(1.5)),
            ]));

        hangboardFormBloc.add(DepthChanged(1.5));
      });

      test('when user changes depth to negative value, should yield state with validDepth set to false', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(validDepth: false),
            ]));

        hangboardFormBloc.add(DepthChanged(-1.5));
      });

    });

    group('RestDurationChanged Tests', () {
      test('when user changes restDuration', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(restDuration: Nullable(3)),
            ]));

        hangboardFormBloc.add(RestDurationChanged(3));
      });

      test(
          'when user changes restDuration to negative value, should yield state with validRestDuration set to false',
          () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(validRestDuration: false),
            ]));

        hangboardFormBloc.add(RestDurationChanged(-3));
      });
    });

    group('RepDurationChanged Tests', () {
      test('when user changes repDuration, should yield state with updated restDuration', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(repDuration: 7),
            ]));

        hangboardFormBloc.add(RepDurationChanged(7));
      });

      test(
          'when user changes repDuration to negative value, should yield state with validRepDuration set to false',
          () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(validRepDuration: false),
            ]));

        hangboardFormBloc.add(RepDurationChanged(-7));
      });
    });

    group('HangsPerSetChanged Tests', () {
      test('when user changes hangsPerSet, should yield state with updated hangsPerSet', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(hangsPerSet: 6),
            ]));

        hangboardFormBloc.add(HangsPerSetChanged(6));
      });

      test(
          'when user changes hangsPerSet to negative value, should yield state with validHangsPerSet set to false',
          () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(validHangsPerSet: false),
            ]));

        hangboardFormBloc.add(HangsPerSetChanged(-6));
      });
    });

    group('ShowRestDurationChanged Tests', () {
      test(
          'emits [initialized, updated state] when user changes showRestDuration, and should wipe out restDuration value',
          () async {
        var secondState = HangboardFormState.initial().update(restDuration: Nullable(180));
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              secondState,
              secondState.update(
                showRestDuration: false,
                restDuration: Nullable(null),
//              hangsPerSet: null,
//              showHangsPerSet: false, -- proposing to only alert user and not forcefully change anything here
              ),
            ]));

        hangboardFormBloc.add(RestDurationChanged(180));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(ShowRestDurationChanged(false));
        //todo: manually turning this off should show an alert that number of hangs must be 1?
        //todo: on toggle: immediately show alert, emit event anyway, update form state, check validation of showRestDuration(false) + hangsPerSet(1) on save?
      });
    });

    group('BreakDurationChanged Tests', () {
      test('when user changes breakDuration, should yield state with updated breakDuration', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(breakDuration: 180),
            ]));

        hangboardFormBloc.add(BreakDurationChanged(180));
      });

      test(
          'when user changes breakDuration to negative value, should yield state with validBreakDuration set to false',
          () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(validBreakDuration: false),
            ]));

        hangboardFormBloc.add(BreakDurationChanged(-180));
      });
    });

    group('NumberOfSetsChanged Tests', () {
      test('when user changes numberOfSets, should yield state with updated numberOfSets', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(numberOfSets: 6),
            ]));

        hangboardFormBloc.add(NumberOfSetsChanged(6));
      });

      test(
          'when user changes numberOfSets to negative value, should yield state with validNumberOfSets set to false',
          () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(validNumberOfSets: false),
            ]));

        hangboardFormBloc.add(NumberOfSetsChanged(-6));
      });
    });

    group('ShowResistanceChanged Tests', () {
      test('when user changes showResistance, should wipe out resistance value', () async {
        var showResistanceChangedState = HangboardFormState.initial().update(showResistance: true);
        var resistanceChangedState = showResistanceChangedState.update(resistance: Nullable(10.5));

        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              showResistanceChangedState,
              resistanceChangedState,
              resistanceChangedState.update(
                resistance: Nullable(null),
                showResistance: false,
              ),
            ]));

        hangboardFormBloc.add(ShowResistanceChanged(true));
        hangboardFormBloc.add(ResistanceChanged(10.5));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(ShowResistanceChanged(false));
      });

      test(
          'when user changes showResistance with invalid resistance, should set isValidResistance to true',
          () async {
        var showResistanceChangedState = HangboardFormState.initial().update(showResistance: true);
        var resistanceChangedState = showResistanceChangedState.update(resistance: Nullable(10.5));
        var resistanceChangedState2 =
            resistanceChangedState.update(resistance: Nullable(null), validResistance: false);

        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              showResistanceChangedState,
              resistanceChangedState,
              resistanceChangedState2,
              resistanceChangedState2.update(
                validResistance: true,
                showResistance: false,
              ),
            ]));

        hangboardFormBloc.add(ShowResistanceChanged(true));
        hangboardFormBloc.add(ResistanceChanged(10.5));
        await Future.delayed(Duration(milliseconds: 900)); // delay for debounced event
        hangboardFormBloc.add(ResistanceChanged(null));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(ShowResistanceChanged(false));
      });
    });

    group('ResistanceChanged Tests', () {
      test('when user changes resistance, should yield state with updated resistance field', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(resistance: Nullable(10.5)),
            ]));

        hangboardFormBloc.add(ResistanceChanged(10.5));
      });

      test(
          'when showResistance is true and resistance is null, should yield state with validResistance set to false',
          () {
        var showResistanceChangedState = HangboardFormState.initial().update(showResistance: true);
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              showResistanceChangedState,
              showResistanceChangedState.update(validResistance: false),
            ]));

        hangboardFormBloc.add(ShowResistanceChanged(true));
        hangboardFormBloc.add(ResistanceChanged(null));
      });
    });

    /*test('emits [initialized, updated state] when resetFlags event occurs', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.update(
                isDuplicate: false, isFailure: false, isSuccess: false),
          ]));

      hangboardFormBloc.add(ResetFlags());
    });*/

    group('InvalidFormSaved Tests', () {
      test(
          'when user saves invalid form, should yield state with autoValidate set to true to show form errors',
          () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState.update(autoValidate: true),
            ]));

        hangboardFormBloc.add(InvalidSave());
      });
    });

    group('ValidFormSaved Tests', () {
      test('when db update occurs successfully, should return state with isSuccess set to true',
          () async {
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

        hangboardFormBloc.add(ShowResistanceChanged(true));
        hangboardFormBloc.add(ResistanceUnitChanged(ResistanceUnit.POUNDS));
        hangboardFormBloc.add(HoldChanged(Hold.HALF_CRIMP));
        hangboardFormBloc
            .add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING_PINKIE));
        hangboardFormBloc.add(HandsChanged(1));
        hangboardFormBloc.add(DepthChanged(14.0));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(RepDurationChanged(10));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(BreakDurationChanged(180));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(ShowRestDurationChanged(false));
        hangboardFormBloc.add(HangsPerSetChanged(1));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(NumberOfSetsChanged(6));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(ResistanceChanged(-25));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event

        hangboardFormBloc.add(ValidSave(cruxUser: cruxUser, cruxWorkout: originalCruxWorkout));
      });

      test('when state is a duplicate exercise, should return state with isDuplicate set to true',
          () async {
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

        hangboardFormBloc.add(ShowResistanceChanged(true));
        hangboardFormBloc.add(ResistanceUnitChanged(ResistanceUnit.POUNDS));
        hangboardFormBloc.add(HoldChanged(Hold.HALF_CRIMP));
        hangboardFormBloc
            .add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING_PINKIE));
        hangboardFormBloc.add(HandsChanged(1));
        hangboardFormBloc.add(DepthChanged(14.0));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(RepDurationChanged(10));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(BreakDurationChanged(180));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(ShowRestDurationChanged(false));
        hangboardFormBloc.add(HangsPerSetChanged(1));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(NumberOfSetsChanged(6));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(ResistanceChanged(-25));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event

        hangboardFormBloc.add(ValidSave(cruxUser: cruxUser, cruxWorkout: originalCruxWorkout));
      });

      test(
          'when db call fails and throws exception, should return state with isFailure set to true',
          () async {
        var cruxUser = TestModelFactory.getTypicalCruxUser();
        var originalCruxWorkout = TestModelFactory.getTypicalCruxWorkout();
        var finalHangboardFormState =
            TestModelFactory.getTypicalOneHandedHangboardWorkoutFormState();

        finalHangboardFormState = finalHangboardFormState.update(isFailure: true, isSuccess: false);

        when(baseWorkoutRepositoryMock.updateWorkout(cruxUser, any)).thenReturn(null);

        expectLater(
            hangboardFormBloc,
            emitsThrough(
              finalHangboardFormState,
            ));

        hangboardFormBloc.add(ShowResistanceChanged(true));
        hangboardFormBloc.add(ResistanceUnitChanged(ResistanceUnit.POUNDS));
        hangboardFormBloc.add(HoldChanged(Hold.HALF_CRIMP));
        hangboardFormBloc
            .add(FingerConfigurationChanged(FingerConfiguration.INDEX_MIDDLE_RING_PINKIE));
        hangboardFormBloc.add(HandsChanged(1));
        hangboardFormBloc.add(DepthChanged(14.0));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(RepDurationChanged(10));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(BreakDurationChanged(180));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(ShowRestDurationChanged(false));
        hangboardFormBloc.add(HangsPerSetChanged(1));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(NumberOfSetsChanged(6));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event
        hangboardFormBloc.add(ResistanceChanged(-25));
        await Future.delayed(Duration(milliseconds: 700)); // delay for debounced event

        hangboardFormBloc.add(ValidSave(cruxUser: cruxUser, cruxWorkout: originalCruxWorkout));
      });
    });
  });
}
