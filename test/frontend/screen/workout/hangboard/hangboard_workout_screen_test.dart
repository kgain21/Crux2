import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/repository/workout/model/crux_workout.dart';
import 'package:crux/backend/repository/workout/model/hangboard_workout.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/exercise/hangboard_exercise_bloc.dart';
import 'package:crux/frontend/screen/workout/hangboard/bloc/workout/hangboard_workout_bloc.dart';
import 'package:crux/frontend/screen/workout/hangboard/hangboard_workout_screen.dart';
import 'package:crux/frontend/screen/workout/timer/bloc/timer_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_util/test_model_factory.dart';
import '../../../../test_util/widget_test_utils.dart';

class HangboardWorkoutBlocMock extends Mock implements HangboardWorkoutBloc {}

class HangboardExerciseBlocMock extends Mock implements HangboardExerciseBloc {}

class TimerBlocMock extends Mock implements TimerBloc {}

void main() {
  var subject;

  NavigatorObserverMock navigatorObserverMock;
  HangboardWorkoutBlocMock hangboardWorkoutBlocMock;
  HangboardExerciseBlocMock hangboardExerciseBlocMock;
  TimerBlocMock timerBlocMock;

  final CruxUser cruxUser = CruxUser(displayName: 'Display Name', email: 'Email', uid: '123');
  var cruxWorkout = TestModelFactory.getTypicalCruxWorkout();
  HangboardWorkout hangboardWorkout;

  setUp(() {
    navigatorObserverMock = NavigatorObserverMock();
    hangboardWorkoutBlocMock = HangboardWorkoutBlocMock();
    hangboardExerciseBlocMock = HangboardExerciseBlocMock();
    timerBlocMock = TimerBlocMock();
    hangboardWorkout = TestModelFactory.getTypicalHangboardWorkout();

    subject = buildTestableWidget(
        HangboardWorkoutScreen(
          hangboardWorkoutBloc: hangboardWorkoutBlocMock,
          hangboardExerciseBloc: hangboardExerciseBlocMock,
          timerBloc: timerBlocMock,
          hangboardWorkout: hangboardWorkout,
        ),
        navigatorObserverMock: navigatorObserverMock);
  });

  tearDown(() {
    hangboardWorkoutBlocMock.close();
  });

  group('HangboardWorkoutScreen structural tests', () {
    testWidgets('test HangboardWorkoutScreen builds correctly', (WidgetTester tester) async {
      final findScaffold = find.byKey(Key('hangboardWorkoutScreenScaffold'));
      await tester.pumpWidget(subject);

      expect(findScaffold, findsOneWidget);
    });
  });

  group('WorkoutFormScreen navigation tests', () {
    testWidgets('Hangboard tile onClick should navigate to hangboard screen',
            (WidgetTester tester) async {
          await tester.pumpWidget(subject);

          final findHangboardTile = find.byKey(Key('hangboardFormTile'));
          await tester.tap(findHangboardTile);
          await tester.pumpAndSettle();

          final Route pushedRoute = verify(navigatorObserverMock.didPush(captureAny, any))
              .captured
              .where((element) => element.settings.name == HangboardWorkoutScreen.routeName)
              .first;

          expect(pushedRoute, isNotNull);
        });
  });
}