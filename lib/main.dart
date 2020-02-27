import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/authentication/authentication_bloc.dart';
import 'package:crux/backend/blocs/simple_bloc_delegate.dart';
import 'package:crux/backend/services/base_authentication_service.dart';
import 'package:crux/backend/services/google_sign_in_firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'frontend/screens/sign_in_screen.dart';

Future<void> main() async {
  /// Needed to add this since there's an await in main()
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(Crux());
}

class Crux extends StatefulWidget {
  /// Static and globally available for testing widget properties
  static final themeData = ThemeData(
    primaryColor: Color(0xFFcfd8dc),
    primaryColorLight: Color(0xFFffffff),
    accentColor: Color(0xFF42b983),
    fontFamily: 'Metropolis',
  );

  @override
  State<StatefulWidget> createState() => CruxState(themeData: themeData);
}

class CruxState extends State<Crux> {
  ThemeData themeData;
  AuthenticationBloc authenticationBloc;
  CredentialManager credentialManager;
  FirebaseAuth firebaseAuth;
  GoogleSignIn googleSignIn;

  CruxState({@required this.themeData});

  @override
  void initState() {
    super.initState();
    credentialManager = CredentialManager();
    firebaseAuth = FirebaseAuth.instance;
    googleSignIn = GoogleSignIn();
    final BaseAuthenticationService authenticationService = GoogleSignInFirebaseAuth(
      credentialManager: credentialManager,
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
    );
    authenticationBloc = AuthenticationBloc(authenticationService: authenticationService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: SignInScreen(authenticationBloc: authenticationBloc),
      routes: {

      },
    );
  }

  @override
  void dispose() {
    authenticationBloc.close();
    super.dispose();
  }
}
