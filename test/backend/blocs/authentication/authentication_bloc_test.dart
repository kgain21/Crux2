import 'package:crux/backend/blocs/authentication/authentication_bloc.dart';
import 'package:crux/backend/blocs/authentication/authentication_event.dart';
import 'package:crux/backend/blocs/authentication/authentication_state.dart';
import 'package:crux/backend/services/base_authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class BaseAuthMock extends Mock implements BaseAuthenticationService {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

void main() {
  BaseAuthMock baseAuthMock;
  FirebaseUserMock firebaseUserMock;

  AuthenticationBloc authenticationBloc;

  setUp(() {
    baseAuthMock = BaseAuthMock();
    firebaseUserMock = FirebaseUserMock();
    authenticationBloc = AuthenticationBloc(authenticationService: baseAuthMock);
  });

  tearDown(() {
    authenticationBloc?.close();
  });

  test('initial state is correct', () {
    expect(authenticationBloc.initialState, AuthenticationUninitialized());
  });

  test('close does not emit new states', () {
    expectLater(
      authenticationBloc,
      emitsInOrder([AuthenticationUninitialized(), emitsDone]),
    );
    authenticationBloc.close();
  });

  group('Google sign in', () {
    test('emits [uninitialized, inProgress, success] with FirebaseUser for normal sign in', () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationInProgress(),
        AuthenticationSuccess(firebaseUser: firebaseUserMock)
      ];

      when(baseAuthMock.signInWithGoogle()).thenAnswer((_) => Future.value(firebaseUserMock));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(GoogleSignInButtonTapped());
    });

    test('emits [uninitialized, inProgress, failure] when sign in fails', () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationInProgress(),
        AuthenticationFailure()
      ];

      when(baseAuthMock.signInWithGoogle()).thenAnswer((_) => Future.value(null));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(GoogleSignInButtonTapped());
    });

    test('emits [uninitialized, inProgress, error] when sign in errors', () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationInProgress(),
        AuthenticationError()
      ];

      when(baseAuthMock.signInWithGoogle())
          .thenAnswer((_) => Future.error(Exception('Google sign in test')));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(GoogleSignInButtonTapped());
    });
  });
}
