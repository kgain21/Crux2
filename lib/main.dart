import 'package:bloc/bloc.dart';
import 'package:crux/backend/application_context.dart';
import 'package:crux/backend/util/injector/injector.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_bloc.dart';
import 'package:crux/frontend/screen/authentication/sign_in_screen.dart';
import 'package:crux/frontend/screen/dashboard/bloc/dashboard_bloc.dart';
import 'package:crux/frontend/screen/dashboard/dashboard_screen.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_bloc.dart';
import 'package:crux/frontend/screen/form/hangboard/hangboard_form_screen.dart';
import 'package:crux/frontend/screen/form/workout/workout_form_screen.dart';
import 'package:crux/frontend/simple_bloc_delegate.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  /// Needed to add this since there's an await in main() - update: not anymore but I'm leaving it JIC
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
//    appBarTheme: AppBarTheme(),
    iconTheme: IconThemeData(
      color: Color(0xFFcfd8dc)
    )
  );

  static final Injector injector = ApplicationContext().initialize(Injector.injector);

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DashboardScreen.routeName:
        final DashboardScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return DashboardScreen(
              cruxUser: args.cruxUser,
              dashboardBloc: injector.get<DashboardBloc>(),
            );
          },
          settings: settings,
        );
      case WorkoutFormScreen.routeName:
        final WorkoutFormScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return WorkoutFormScreen(
              cruxUser: args.cruxUser,
              cruxWorkout: args.cruxWorkout,
//              dashboardBloc: injector.get<DashboardBloc>(),
            );
          },
          settings: settings,
        );
      case HangboardFormScreen.routeName:
        final WorkoutFormScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return HangboardFormScreen(
              hangboardFormBloc: injector.get<HangboardFormBloc>(),
              cruxUser: args.cruxUser,
              cruxWorkout: args.cruxWorkout,
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
