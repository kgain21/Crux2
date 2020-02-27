import 'package:bloc_test/bloc_test.dart';
import 'package:crux/backend/blocs/authentication/authentication_bloc.dart';
import 'package:crux/backend/blocs/authentication/authentication_event.dart';
import 'package:crux/backend/blocs/authentication/authentication_state.dart';
import 'package:crux/frontend/screens/dashboard_screen.dart';
import 'package:crux/frontend/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as dartTest;

import '../../test_utils/widget_test_utils.dart';

class AuthenticationBlocMock extends Mock implements AuthenticationBloc {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

void main() {
  AuthenticationBlocMock authenticationBlocMock;
  FirebaseUserMock firebaseUserMock;
  MockNavigatorObserver mockNavigatorObserver;

  var subject;

  dartTest.setUp(() {
    firebaseUserMock = FirebaseUserMock();
    authenticationBlocMock = AuthenticationBlocMock();
    mockNavigatorObserver = MockNavigatorObserver();

    subject = buildTestableWidget(SignInScreen(authenticationBloc: authenticationBlocMock),
        mockNavigatorObserver: mockNavigatorObserver);

    // have to pass the initial state to the widget manually since it's a stub
    whenListen(authenticationBlocMock, Stream.value(AuthenticationUninitialized()));
  });

  dartTest.tearDown(() {
    authenticationBlocMock?.close();
  });

  group('Sign In Screen tests', () {
    testWidgets('Test Sign In Screen basic structure with AuthenticationUnitialized state',
        (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      final findBlocBuilder = find.byKey(Key('authenticationBlocBuilder'));
      final findScaffold = find.byKey(Key('signInScaffold'));
      final findStack = find.byKey(Key('signInStack'));
      final findBackgroundImage =
          find.descendant(of: findStack, matching: find.byKey(Key('backgroundImage')));
      final findContentOutlineOverlay =
          find.descendant(of: findStack, matching: find.byKey(Key('contentOutlineOverlay')));
      final findTitleButtonOverlay =
          find.descendant(of: findStack, matching: find.byKey(Key('titleButtonOverlay')));

      expect(findBlocBuilder, findsOneWidget);
      expect(findScaffold, findsOneWidget);
      expect(findStack, findsOneWidget);

      var stack = tester.widget(findStack) as Stack;
      expect(stack.children.length, 3);
      expect(stack.children[0], tester.widget(findBackgroundImage));
      expect(stack.children[1], tester.widget(findContentOutlineOverlay));
      expect(stack.children[2], tester.widget(findTitleButtonOverlay));
    });

    testWidgets('Test Google Sign In button interaction with AuthenticationUninitialized state',
        (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      final findGoogleSignInButton = find.byKey(Key('signInGoogleButton'));

      await tester.tap(findGoogleSignInButton);

      verify(authenticationBlocMock.add(dartTest.TypeMatcher<GoogleSignInButtonTapped>()));
    });

    testWidgets('Test build with AuthenticationSuccess state should push /dashboard route',
        (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      whenListen(authenticationBlocMock,
          Stream.value(AuthenticationSuccess(firebaseUser: firebaseUserMock)));

      dartTest.expectLater(
          authenticationBlocMock,
          emitsInOrder([
            AuthenticationSuccess(firebaseUser: firebaseUserMock)
          ]));

      when(firebaseUserMock.displayName).thenReturn('Display Name');

      await tester.pumpAndSettle();

      final Route pushedRoute = verify(mockNavigatorObserver.didPush(captureAny, any)).captured.single;
      var result = pushedRoute.currentResult.toString();
      expect(find.byType(DashboardScreen, skipOffstage: false), findsOneWidget);
    });

    testWidgets('Test build with AuthenticationFailure state', (WidgetTester tester) async {
      await tester.pumpWidget(subject);
    });

    testWidgets('Test build with AuthenticationError state', (WidgetTester tester) async {
      await tester.pumpWidget(subject);
    });
  });
}
