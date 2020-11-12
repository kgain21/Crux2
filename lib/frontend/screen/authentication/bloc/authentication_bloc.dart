import 'package:bloc/bloc.dart';
import 'package:crux/backend/service/authentication/authentication_service.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_event.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_state.dart';
import 'package:flutter/widgets.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  BaseAuthenticationService authenticationService;

  AuthenticationBloc({@required this.authenticationService});

  @override
  get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(event) {
    if (event is GoogleSignInButtonTapped) {
      return _mapGoogleSignInButtonTappedEventToState(event);
    }
    if (event is AppBarSignOutButtonTapped) {
      return _mapAppBarSignOutButtonTapped(event);
    }
    return null;
  }

  Stream<AuthenticationState> _mapGoogleSignInButtonTappedEventToState(
      GoogleSignInButtonTapped event) async* {
    yield AuthenticationInProgress();
    yield await authenticationService.signIn().then((cruxUser) {
      if (null != cruxUser) {
        return AuthenticationSuccess(cruxUser: cruxUser);
      } else {
        return AuthenticationFailure();
      }
    }).catchError((error) {
      print(error);
      return AuthenticationError();
    });
  }

  Stream<AuthenticationState> _mapAppBarSignOutButtonTapped(
      AppBarSignOutButtonTapped event) async* {
    yield AuthenticationInProgress();
    yield await authenticationService.signOut().then((cruxUser) {
      if (null != cruxUser) {
        return AuthenticationUninitialized();
      } else {
        return AuthenticationFailure();
      }
    }).catchError((error) {
      print(error);
      return AuthenticationError();
    });
  }
}
