import 'package:crux/model/crux_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final CruxUser cruxUser = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: Key('dashboardScaffold'),
//      drawer: dashboardDrawer(),
      body: Container(
        child: Center(child: Text('Welcome, ${cruxUser.displayName.split(' ').first}')),
      ),
    );
  }
}
