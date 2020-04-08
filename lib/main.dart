import 'package:bloc/bloc.dart';
import 'package:crux/backend/bloc/authentication/authentication_bloc.dart';
import 'package:crux/backend/bloc/simple_bloc_delegate.dart';
import 'package:crux/backend/service/authentication/base_authentication_service.dart';
import 'package:crux/backend/service/authentication/google_sign_in_firebase_auth.dart';
import 'package:crux/frontend/screen/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'frontend/screen/sign_in_screen.dart';

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
    errorColor: Color(0xFFFF6666),
    snackBarTheme: SnackBarThemeData(),
    fontFamily: 'Metropolis',
  );

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DashboardScreen.routeName:
        final DashboardScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return DashboardScreen(
              cruxUser: args.cruxUser,
            );
          },
          settings: settings,
        );
      default:
        return null;
    }
  }

  @override
  State<StatefulWidget> createState() =>
      CruxState(themeData: themeData, onGenerateRoute: onGenerateRoute);
}

class CruxState extends State<Crux> {
  ThemeData themeData;

//  Map<String, WidgetBuilder> routes;
  Function onGenerateRoute;
  AuthenticationBloc authenticationBloc;
  CredentialManager credentialManager;
  FirebaseAuth firebaseAuth;
  GoogleSignIn googleSignIn;

  CruxState({@required this.themeData, @required this.onGenerateRoute});

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
//      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }

  @override
  void dispose() {
    authenticationBloc.close();
    super.dispose();
  }
}
