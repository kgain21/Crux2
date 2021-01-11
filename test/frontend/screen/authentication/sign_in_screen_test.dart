import 'package:bloc_test/bloc_test.dart';
import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_bloc.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_event.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_state.dart';
import 'package:crux/frontend/screen/authentication/sign_in_screen.dart';
import 'package:crux/frontend/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as dartTest;

import '../../../test_util/widget_test_utils.dart';


class AuthenticationBlocMock extends MockBloc<AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  AuthenticationBlocMock authenticationBlocMock;
  NavigatorObserverMock navigatorObserverMock;

  final CruxUser cruxUser = CruxUser(displayName: 'Display Name', email: 'Email', uid: '123');

  var subject;

  dartTest.setUp(() {
    authenticationBlocMock = AuthenticationBlocMock();
    navigatorObserverMock = NavigatorObserverMock();

    subject = buildTestableWidget(SignInScreen(authenticationBloc: authenticationBlocMock),
        navigatorObserverMock: navigatorObserverMock);
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

    testWidgets('Test Sign In Screen basic structure with AuthenticationUninitialized state',
        (WidgetTester tester) async {
//      whenListen(authenticationBlocMock, Stream.value(AuthenticationUninitialized()));

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
      'Test build with AuthenticationSuccess state should push /dashboard route with cruxUser',
      (WidgetTester tester) async {
        whenListen(
          authenticationBlocMock,
          Stream.fromIterable([
            AuthenticationInProgress(),
            AuthenticationSuccess(cruxUser: cruxUser),
          ]),
        );

        await tester.pumpWidget(subject);

        final Route pushedRoute =
            verify(navigatorObserverMock.didPush(captureAny, any)).captured[1];
        expect(pushedRoute.settings.name, DashboardScreen.routeName);
        expect(pushedRoute.settings.arguments, isA<DashboardScreenArguments>());
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
