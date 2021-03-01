class WorkoutFormBlocMock extends Mock implements WorkoutFormBloc {}

void main() {
  var subject;

  NavigatorObserverMock navigatorObserverMock;
  WorkoutFormBlocMock workoutFormBlocMock;

  final CruxUser cruxUser = CruxUser(displayName: 'Display Name', email: 'Email', uid: '123');

  setUp(() {
    navigatorObserverMock = NavigatorObserverMock();
    workoutFormBlocMock = WorkoutFormBlocMock();

    var cruxWorkout = CruxWorkout((cw) => (cw..workoutDate = DateTime.now()).build());

    subject = buildTestableWidget(
        WorkoutFormScreen(
          workoutFormBloc: workoutFormBlocMock,
          cruxWorkout: cruxWorkout,
        ),
        navigatorObserverMock: navigatorObserverMock);
  });

  tearDown(() {
    workoutFormBlocMock.close();
  });

  group('WorkoutFormScreen structural tests', () {
    testWidgets('test WorkoutFormScreen builds correctly', (WidgetTester tester) async {
      final findScaffold = find.byKey(Key('workoutFormScaffold'));
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
              .where((element) => element.settings.name == HangboardFormScreen.routeName)
              .first;

          expect(pushedRoute, isNotNull);
        });
  });
}