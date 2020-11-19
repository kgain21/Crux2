import 'package:bloc_test/bloc_test.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_bloc.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_state.dart';
import 'package:crux/frontend/screen/form/hangboard/hangboard_form_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_util/widget_test_utils.dart';

class HangboardFormBlocMock extends Mock implements HangboardFormBloc {}

void main() {
  var subject;

  NavigatorObserverMock navigatorObserverMock;
  HangboardFormBlocMock hangboardFormBlocMock;

  final CruxUser cruxUser = CruxUser(displayName: 'Display Name', email: 'Email', uid: '123');

  setUp(() {
    navigatorObserverMock = NavigatorObserverMock();
    hangboardFormBlocMock = HangboardFormBlocMock();

    subject = buildTestableWidget(
        HangboardFormScreen(
            hangboardFormBloc: hangboardFormBlocMock,
            cruxUser: cruxUser,
            cruxWorkout: CruxWorkout((cw) => (cw..workoutDate = DateTime.now()).build())),
        navigatorObserverMock: navigatorObserverMock);
  });

  tearDown(() {
    hangboardFormBlocMock?.close();
  });

  group('HangboardFormScreen structural tests', () {
    final findScaffold = find.byKey(Key('hangboardFormScaffold'));
    final findUnitsTile = find.byKey(Key('unitSelector'));
    final findHoldDropdownTile = find.byKey(Key('holdDropdownTile'));
    final findDurationTile = find.byKey(Key('durationTile'));
    final findHangsPerSetTile = find.byKey(Key('hangsPerSetTile'));
    final findBreakDurationTile = find.byKey(Key('breakDurationTile'));
    final findNumberOfSetsTile = find.byKey(Key('numberOfSetsTile'));
    final findResistanceTile = find.byKey(Key('resistanceTile'));
    final findSaveButton = find.byKey(Key('saveButton'));

//  Not shown in initial state
    final findDepthTile = find.byKey(Key('depthTile'));
    final findFingerConfigurationDropdownTile = find.byKey(Key('fingerConfigurationDropdownTile'));

    testWidgets('test HangboardFormScreen builds correctly', (WidgetTester tester) async {
      var hangboardFormState = HangboardFormState.initial();

      when(hangboardFormBlocMock.state).thenReturn(hangboardFormState);
      whenListen(hangboardFormBlocMock, Stream.value(hangboardFormState));

      await tester.pumpWidget(subject);

      expect(findScaffold, findsOneWidget);
      expect(findUnitsTile, findsOneWidget);
      expect(findHoldDropdownTile, findsOneWidget);
      expect(findDurationTile, findsOneWidget);
      expect(findHangsPerSetTile, findsOneWidget);
      expect(findBreakDurationTile, findsOneWidget);
      expect(findNumberOfSetsTile, findsOneWidget);
      expect(findResistanceTile, findsOneWidget);
      expect(findSaveButton, findsOneWidget);

      expect(findFingerConfigurationDropdownTile, findsNothing);
      expect(findDepthTile, findsNothing);
    });
  });
}
