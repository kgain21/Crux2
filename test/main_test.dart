import 'package:crux/frontend/screens/sign_in_screen.dart';
import 'package:crux/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Main app smoke test', () {
    testWidgets('High level Main App elements test', (WidgetTester tester) async {
      await tester.pumpWidget(Crux());

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(SignInScreen), findsOneWidget);
      expect(find.byType(Theme), findsOneWidget);
    });

    testWidgets('Test Theme Data properties', (WidgetTester tester) async {
      await tester.pumpWidget(Crux());

      var theme = tester.widget(find.byType(Theme)) as Theme;

      expect(theme.data, isNotNull);
      expect(theme.data.primaryColorLight, Crux.themeData.primaryColorLight);
      expect(theme.data.accentColor, Crux.themeData.accentColor);
    });
  });
}
