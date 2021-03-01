import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/util/model/state_container.dart';
import 'package:crux/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

/// Test method that wraps given widget in StateContainer/MaterialApp for testing more
/// representative of real use.
Widget buildTestableWidget(
  Widget widget, {
  NavigatorObserverMock navigatorObserverMock,
  CruxUser cruxUser,
}) {
  return StateContainer(
    child: MaterialApp(
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
    ),
    cruxUser: cruxUser,
  );
}
