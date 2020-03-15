import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final FirebaseUser firebaseUser = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: Key('dashboardScaffold'),
      body: Container(
        child: Center(child: Text('Welcome, ${firebaseUser.displayName.split(' ').first}')),
      ),
    );
  }
}
