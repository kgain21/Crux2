import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/authentication/authentication_bloc.dart';
import 'package:crux/backend/blocs/simple_bloc_delegate.dart';
import 'package:crux/backend/services/base_auth.dart';
import 'package:crux/backend/services/google_sign_in_firebase_auth.dart';
import 'package:flutter/material.dart';

import 'frontend/screens/sign_in_screen.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(Crux());
}

//todo: make this a stateful widget now - apparently no performance difference betw the two
class Crux extends StatelessWidget {

  static final themeData = ThemeData(
      primaryColor: Color(0xFFcfd8dc),
      primaryColorLight: Color(0xFFffffff),
      accentColor: Color(0xFF42b983),
      fontFamily: 'Metropolis',
  );

  @override
  Widget build(BuildContext context) {
    final BaseAuth authenticationService = GoogleSignInFirebaseAuth();
    final AuthenticationBloc authenticationBloc = AuthenticationBloc(authenticationService: authenticationService);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: SignInScreen(authenticationBloc: authenticationBloc),
    );
  }
}
