import 'package:bloc/bloc.dart';
import 'package:crux/backend/application_context.dart';
import 'package:crux/backend/bloc/authentication/authentication_bloc.dart';
import 'package:crux/backend/bloc/simple_bloc_delegate.dart';
import 'package:crux/backend/util/injector/injector.dart';
import 'package:crux/frontend/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'frontend/screen/sign_in_screen.dart';

Future<void> main() async {
  /// Needed to add this since there's an await in main()
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(Crux());
}

class Crux extends StatelessWidget {

  /// Static and globally available for testing widget properties
  static final ThemeData themeData = ThemeData(
    primaryColor: Color(0xFFcfd8dc),
    primaryColorLight: Color(0xFFffffff),
    accentColor: Color(0xFF42b983),
    errorColor: Color(0xFFFF6666),
    snackBarTheme: SnackBarThemeData(),
    fontFamily: 'Metropolis',
  );

  final Injector injector = ApplicationContext().initialize(Injector.injector);

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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: SignInScreen(authenticationBloc: injector.get<AuthenticationBloc>()),
      onGenerateRoute: onGenerateRoute,
    );
  }
}