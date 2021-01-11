import 'dart:ui';

import 'package:crux/frontend/screen/authentication/bloc/authentication_bloc.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_event.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_state.dart';
import 'package:crux/frontend/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  const SignInScreen({@required this.authenticationBloc});

  @override
  State<StatefulWidget> createState() =>
      _SignInScreenState(authenticationBloc);
}

class _SignInScreenState extends State<SignInScreen> {
  static const routeName = '/';

  final AuthenticationBloc authenticationBloc;

  _SignInScreenState(this.authenticationBloc);

  @override
  Widget build(context) {
    return Scaffold(
      key: Key('signInScaffold'),
      body: BlocProvider(
        create: (_) => authenticationBloc,
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          key: Key('authenticationBlocListener'),
          listener: _listenForAuthenticationState,
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            cubit: authenticationBloc,
            key: Key('authenticationBlocBuilder'),
            builder: (context, state) {
              return Center(
                child: Stack(
                  key: Key('signInStack'),
                  children: <Widget>[
                    buildBackgroundImage(context),
                    buildContentOutlineOverlay(context),
                    buildTitleButtonOverlay(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _listenForAuthenticationState(context, state) {
    if (state is AuthenticationSuccess) {
      Navigator.pushNamed(
        context,
        DashboardScreen.routeName,
        arguments: DashboardScreenArguments(state.cruxUser),
      );
    }
    else if (state is AuthenticationFailure) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        key: Key('failureSnackBar'),
        content: Text(
            'Sign in authentication failed. Please check your credentials and try again or continue as a guest.'),
        duration: Duration(seconds: 5),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
    else if (state is AuthenticationError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        key: Key('errorSnackBar'),
        content:
            Text('Network error occurred signing in. Please try again or continue as a guest.'),
        duration: Duration(seconds: 5),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  Widget buildBackgroundImage(BuildContext context) {
    return Container(
      key: Key('backgroundImage'),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            'assets/images/gym_climber_crimping.jpg',
          ),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        ),
      ),
    );
  }

  Widget buildContentOutlineOverlay(BuildContext context) {
    return Center(
      key: Key('contentOutlineOverlay'),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .5,
          maxWidth: MediaQuery.of(context).size.width * .91,
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.75),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitleButtonOverlay(BuildContext context) {
    return Column(
      key: Key('titleButtonOverlay'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildTitleRow(context),
        buildSignInGoogleButtonRow(context),
        buildSignInGuestButtonRow(context),
      ],
    );
  }

  Widget buildTitleRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Crux',
            key: Key('signInTitle'),
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }

  Widget buildSignInGoogleButtonRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 45.0,
          minWidth: 275.0,
        ),
        child: RaisedButton(
          key: Key('signInGoogleButton'),
          onPressed: () => authenticationBloc.add(GoogleSignInButtonTapped()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/images/google_logo.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'SIGN IN WITH GOOGLE',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget buildSignInGuestButtonRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 45.0,
          minWidth: 275.0,
        ),
        child: RaisedButton(
          key: Key('signInGuestButton'),
          onPressed: () => null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'CONTINUE AS A GUEST',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    authenticationBloc.close();
    super.dispose();
  }
}
