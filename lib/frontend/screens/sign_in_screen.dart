import 'dart:ui';

import 'package:crux/backend/blocs/authentication/authentication_bloc.dart';
import 'package:crux/backend/blocs/authentication/authentication_event.dart';
import 'package:crux/backend/blocs/authentication/authentication_state.dart';
import 'package:crux/frontend/screens/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;

  SignInScreen({Key key, @required this.authenticationBloc}) : super(key: key);

  @override
  Widget build(context) {
    return BlocListener(
      bloc: authenticationBloc,
      listener: (context, state) {
        if(state is AuthenticationSuccess) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
        }
      },
      child: BlocBuilder(
        key: Key('authenticationBlocBuilder'),
        bloc: authenticationBloc,
        builder: (context, state) {
          return Scaffold(
            key: Key('signInScaffold'),
            body: Center(
              child: Stack(
                key: Key('signInStack'),
                children: <Widget>[
                  buildBackgroundImage(context),
                  buildContentOutlineOverlay(context),
                  buildTitleButtonOverlay(context),
                ],
              ),
            ),
          );
        },
      ),
    );
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
          maxHeight: MediaQuery.of(context).size.height * .45,
          maxWidth: MediaQuery.of(context).size.width * .9,
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
        constraints: BoxConstraints(maxHeight: 45.0, minWidth: 275.0,),
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
}
