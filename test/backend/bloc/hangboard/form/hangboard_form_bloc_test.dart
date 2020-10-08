import 'package:crux/backend/bloc/hangboard/form/hangboard_form_bloc.dart';
import 'package:crux/backend/bloc/hangboard/form/hangboard_form_event.dart';
import 'package:crux/backend/bloc/hangboard/form/hangboard_form_state.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:crux/model/unit.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../dashboard/dashboard_bloc_test.dart';

void main() {
  BaseWorkoutRepositoryMock baseWorkoutRepositoryMock;
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

    group('hold changed tests emits [initialized, updated state]', () {
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

    test('emits [initialized, updated state] when user changes timeOff', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(restDuration: 3),
          ]));

      hangboardFormBloc.add(TimeOffChanged(3));
    });

    test('emits [initialized, updated state] when user changes timeOn', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(repDuration: 7),
          ]));

      hangboardFormBloc.add(TimeOnChanged(7));
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

    test('emits [initialized, updated state] when user changes timeBetweenSets', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(breakDuration: 180),
          ]));

      hangboardFormBloc.add(TimeBetweenSetsChanged(180));
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
      test('when ', () {
        var initialHangboardFormState = HangboardFormState.initial();
        expectLater(
            hangboardFormBloc,
            emitsInOrder([
              initialHangboardFormState,
              initialHangboardFormState.copyWith(),
            ]));

        //todo: left off here - think about UI flow - saving each hbExercise individually will mean a lot of
        //todo: repeated user interaction - can I simplify this?
        //todo: also trying to figure out expected state after save - should return success flag? should save
        //todo: hb model to repo - can mock that out...
        when(baseWorkoutRepositoryMock.saveHangboardExercise(initialHangboardFormState, cruxWorkout))
            .thenAnswer((_) => Future.value(true));

        hangboardFormBloc.add(ValidSave());
      });
    });
  });
}
