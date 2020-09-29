import 'package:crux/backend/bloc/hangboard/form/hangboard_form_bloc.dart';
import 'package:crux/backend/bloc/hangboard/form/hangboard_form_event.dart';
import 'package:crux/backend/bloc/hangboard/form/hangboard_form_state.dart';
import 'package:crux/model/finger_configuration.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:crux/model/unit.dart';
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

    test('emits [initialized, updated state] when user changes hold', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(hold: Hold.MEDIUM_PINCH),
          ]));

      hangboardFormBloc.add(HoldChanged(Hold.MEDIUM_PINCH));
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
            initialHangboardFormState.copyWith(timeOff: 3),
          ]));

      hangboardFormBloc.add(TimeOffChanged(3));
    });

    test('emits [initialized, updated state] when user changes timeOn', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(timeOn: 7),
          ]));

      hangboardFormBloc.add(TimeOnChanged(7));
    });

    test('emits [initialized, updated state] when user changes hangsPerSet', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(hangsPersSet: 6),
          ]));

      hangboardFormBloc.add(HangsPerSetChanged(6));
    });

    test('emits [initialized, updated state] when user changes hangsPerSet', () {
      var initialHangboardFormState = HangboardFormState.initial();
      expectLater(
          hangboardFormBloc,
          emitsInOrder([
            initialHangboardFormState,
            initialHangboardFormState.copyWith(hangsPersSet: 6),
          ]));

      hangboardFormBloc.add(HangsPerSetChanged(6));
    });
  });
}
