import 'package:crux/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

/// Test method that wraps given widget in MaterialApp for testing more representative of real use
Widget buildTestableWidget(Widget widget, {NavigatorObserverMock navigatorObserverMock}) {
  return MaterialApp(
    /// Test theme properties on widgets
    theme: Crux.themeData,
//    routes: Crux.routes,
    home: Builder(
      builder: (context) {
        return widget;
      },
    ),
    navigatorObservers: [navigatorObserverMock],
    onGenerateRoute: Crux.onGenerateRoute,
  );
}
