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

import '../../backend/blocs/authentication/authentication_bloc_test.dart';
import '../../test_utils/widget_test_utils.dart';

class AuthenticationBlocMock extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

void main() {
  AuthenticationBlocMock authenticationBlocMock;
  CruxUserMock cruxUserMock;
  MockNavigatorObserver mockNavigatorObserver;

  var subject;

  dartTest.setUp(() {
    cruxUserMock = CruxUserMock();
    authenticationBlocMock = AuthenticationBlocMock();
    mockNavigatorObserver = MockNavigatorObserver();

    subject = buildTestableWidget(SignInScreen(authenticationBloc: authenticationBlocMock),
        mockNavigatorObserver: mockNavigatorObserver);
  });

  dartTest.tearDown(() {
    authenticationBlocMock?.close();
  });

  group('Sign In Screen tests', () {
    final findBlocBuilder = find.byKey(Key('authenticationBlocBuilder'));
    final findScaffold = find.byKey(Key('signInScaffold'));
    final findStack = find.byKey(Key('signInStack'));
    final findBackgroundImage =
        find.descendant(of: findStack, matching: find.byKey(Key('backgroundImage')));
    final findContentOutlineOverlay =
        find.descendant(of: findStack, matching: find.byKey(Key('contentOutlineOverlay')));
    final findTitleButtonOverlay =
        find.descendant(of: findStack, matching: find.byKey(Key('titleButtonOverlay')));
    final findGoogleSignInButton = find.byKey(Key('signInGoogleButton'));
    final findFailureSnackBar = find.byKey(Key('failureSnackBar'));
    final findErrorSnackBar = find.byKey(Key('errorSnackBar'));

    testWidgets('Test Sign In Screen basic structure with AuthenticationUnitialized state',
        (WidgetTester tester) async {
      whenListen(authenticationBlocMock, Stream.value(AuthenticationUninitialized()));

      await tester.pumpWidget(subject);

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

      await tester.tap(findGoogleSignInButton);

      verify(authenticationBlocMock.add(argThat(isA<GoogleSignInButtonTapped>()))).called(1);
    });

    testWidgets(
      'Test build with AuthenticationSuccess state should push /dashboard route with firebaseUser',
      (WidgetTester tester) async {
        when(cruxUserMock.displayName).thenReturn('Display Name');

        whenListen(
          authenticationBlocMock,
          Stream.fromIterable([
            AuthenticationInProgress(),
            AuthenticationSuccess(cruxUser: cruxUserMock),
          ]),
        );

        await tester.pumpWidget(subject);

        await tester.pumpAndSettle();

        final Route pushedRoute =
            verify(mockNavigatorObserver.didPush(captureAny, any)).captured[1];
        expect(pushedRoute.settings.name, DashboardScreen.routeName);
        expect(pushedRoute.settings.arguments, cruxUserMock);

        expect(find.byType(DashboardScreen), findsOneWidget);
      },
    );

    testWidgets(
      'Test build with AuthenticationFailure state',
      (WidgetTester tester) async {
        whenListen(
          authenticationBlocMock,
          Stream.fromIterable([
            AuthenticationInProgress(),
            AuthenticationFailure(),
          ]),
        );

        await tester.pumpWidget(subject);
        await tester.pump();
        expect(findFailureSnackBar, findsOneWidget);
      },
    );

    testWidgets(
      'Test build with AuthenticationError state',
      (WidgetTester tester) async {
        whenListen(
          authenticationBlocMock,
          Stream.fromIterable([
            AuthenticationInProgress(),
            AuthenticationError(),
          ]),
        );

        await tester.pumpWidget(subject);
        await tester.pump();

        expect(findErrorSnackBar, findsOneWidget);
      },
    );
  });
}
