import 'package:bloc_test/bloc_test.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/frontend/screen/form/hangboard/hangboard_form_screen.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_bloc.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_state.dart';
import 'package:crux/frontend/screen/form/workout/workout_form_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_util/widget_test_utils.dart';

class WorkoutFormBlocMock extends Mock implements WorkoutFormBloc {}

void main() {
  var subject;

  NavigatorObserverMock navigatorObserverMock;
  WorkoutFormBlocMock workoutFormBlocMock;

  final CruxUser cruxUser = CruxUser(displayName: 'Display Name', email: 'Email', uid: '123');
  var cruxWorkout = CruxWorkout((cw) => (cw..workoutDate = DateTime.now()).build());

  var workoutFormUninitialized = WorkoutFormUninitialized();

  setUp(() {
    navigatorObserverMock = NavigatorObserverMock();
    workoutFormBlocMock = WorkoutFormBlocMock();

    subject = buildTestableWidget(
      WorkoutFormScreen(
        workoutFormBloc: workoutFormBlocMock,
        cruxWorkout: cruxWorkout,
      ),
      navigatorObserverMock: navigatorObserverMock,
      cruxUser: cruxUser,
    );
  });

  tearDown(() {
    workoutFormBlocMock.close();
  });

  group('WorkoutFormScreen structural tests', () {
    testWidgets('test WorkoutFormScreen builds correctly', (WidgetTester tester) async {
      when(workoutFormBlocMock.state).thenReturn(workoutFormUninitialized);

      final findScaffold = find.byKey(Key('workoutFormScaffold'));
      await tester.pumpWidget(subject);

      expect(findScaffold, findsOneWidget);
    });
  });

  group('WorkoutFormScreen navigation tests', () {
    testWidgets('Hangboard tile onClick should navigate to hangboard screen',
        (WidgetTester tester) async {
      when(workoutFormBlocMock.state).thenReturn(workoutFormUninitialized);

      whenListen(
        workoutFormBlocMock,
        Stream.fromIterable([
          WorkoutFormUninitialized(),
          WorkoutFormInitializationInProgress(),
          WorkoutFormInitializationSuccess(cruxWorkout: cruxWorkout),
        ]),
      );

      await tester.pumpWidget(subject);
      await tester.pumpAndSettle();

      final findHangboardTile = find.byKey(Key('hangboardWorkoutTile'));
      await tester.tap(findHangboardTile);

      final Route pushedRoute = verify(navigatorObserverMock.didPush(captureAny, any))
          .captured
          .where((element) => element.settings.name == HangboardFormScreen.routeName)
          .first;

      expect(pushedRoute, isNotNull);
    });
  });
}
