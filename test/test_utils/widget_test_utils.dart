import 'package:crux/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildTestableWidget(Widget widget) {
  return MaterialApp(
    theme: Crux.themeData,
    home: Builder(
      builder: (context) {
        return widget;
      },
    ),
  );
}
