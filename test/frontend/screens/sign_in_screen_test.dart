import 'package:crux/backend/blocs/authentication/authentication_bloc.dart';
import 'package:crux/backend/blocs/authentication/authentication_event.dart';
import 'package:crux/frontend/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as dartTest;

import '../../test_utils/widget_test_utils.dart';

class AuthenticationBlocMock extends Mock implements AuthenticationBloc {}

void main() {
  var subject;
  AuthenticationBlocMock authenticationBlocMock;

  dartTest.setUp(() {
    authenticationBlocMock = AuthenticationBlocMock();
    subject = buildTestableWidget(SignInScreen(authenticationBloc: authenticationBlocMock));
  });

  dartTest.tearDown(() {
    authenticationBlocMock?.close();
  });

  group('Sign In Screen tests', () {
    testWidgets('Test Sign In Screen basic structure', (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      final findScaffold = find.byType(Scaffold);
      final findStack = find.byKey(Key('signInStack'));
      final findBackgroundImage =
          find.descendant(of: findStack, matching: find.byKey(Key('backgroundImage')));
      final findContentOutlineOverlay =
          find.descendant(of: findStack, matching: find.byKey(Key('contentOutlineOverlay')));
      final findTitleButtonOverlay =
          find.descendant(of: findStack, matching: find.byKey(Key('titleButtonOverlay')));

      expect(findScaffold, findsOneWidget);
      expect(findStack, findsOneWidget);

      var stack = tester.widget(findStack) as Stack;
      expect(stack.children.length, 3);
      expect(stack.children[0], tester.widget(findBackgroundImage));
      expect(stack.children[1], tester.widget(findContentOutlineOverlay));
      expect(stack.children[2], tester.widget(findTitleButtonOverlay));
    });

    testWidgets('Test Google Sign In button interaction', (WidgetTester tester) async {
      await tester.pumpWidget(subject);

      final findGoogleSignInButton = find.byKey(Key('signInGoogleButton'));

      await tester.tap(findGoogleSignInButton);
      
      verify(authenticationBlocMock.add(dartTest.TypeMatcher<GoogleSignInButtonTapped>()));
    });
  });
}
