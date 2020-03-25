import 'package:crux/model/crux_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
  final CruxUser cruxUser;

  DashboardScreen({@required this.cruxUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('dashboardScaffold'),
//      drawer: dashboardDrawer(),
      body: Container(
        child: Center(child: Text('Welcome, ${cruxUser.displayName.split(' ').first}')),
      ),
    );
  }
}

class DashboardScreenArguments {
  final CruxUser cruxUser;

  DashboardScreenArguments(this.cruxUser);
}
