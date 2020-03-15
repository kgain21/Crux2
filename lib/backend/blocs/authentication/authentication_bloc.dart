import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/authentication/authentication_event.dart';
import 'package:crux/backend/blocs/authentication/authentication_state.dart';
import 'package:crux/backend/services/base_authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return null;
  }

  Stream<AuthenticationState> _mapGoogleSignInButtonTappedEventToState(
      GoogleSignInButtonTapped event) async* {
    yield AuthenticationInProgress();
    try {
      FirebaseUser firebaseUser = await authenticationService.signInWithGoogle();
      if(null != firebaseUser) {
        yield AuthenticationSuccess(firebaseUser: firebaseUser);
      } else {
        yield AuthenticationFailure();
      }
    } catch (error) {
      print(error);
      yield AuthenticationError();
    }
  }
}
