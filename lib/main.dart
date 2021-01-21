import 'package:bloc/bloc.dart';
import 'package:crux/backend/application_context.dart';
import 'package:crux/backend/repository/preferences.dart';
import 'package:crux/backend/util/injector/injector.dart';
import 'package:crux/backend/util/model/state_container.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_bloc.dart';
import 'package:crux/frontend/screen/authentication/sign_in_screen.dart';
import 'package:crux/frontend/screen/dashboard/bloc/dashboard_bloc.dart';
import 'package:crux/frontend/screen/dashboard/dashboard_screen.dart';
import 'package:crux/frontend/screen/form/hangboard/bloc/hangboard_form_bloc.dart';
import 'package:crux/frontend/screen/form/hangboard/hangboard_form_screen.dart';
import 'package:crux/frontend/screen/form/workout/bloc/workout_form_screen_bloc.dart';
import 'package:crux/frontend/screen/form/workout/workout_form_screen.dart';
import 'package:crux/frontend/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Preferences.sharedPreferences = await SharedPreferences.getInstance();
  Bloc.observer = SimpleBlocObserver();

  runApp(StateContainer(
    child: Crux(),
  ));
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
      iconTheme: IconThemeData(color: Colors.black38));

  static final Injector injector = ApplicationContext().initialize(Injector.injector);

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DashboardScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return DashboardScreen(
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
              workoutFormScreenBloc: injector.get<WorkoutFormBloc>(),
              cruxWorkout: args.cruxWorkout,
            );
          },
          settings: settings,
        );
      case HangboardFormScreen.routeName:
        final HangboardFormScreenArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return HangboardFormScreen(
              hangboardFormBloc: injector.get<HangboardFormBloc>(),
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
