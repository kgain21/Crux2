import 'package:crux/backend/blocs/authentication/authentication_bloc.dart';
import 'package:crux/backend/blocs/authentication/authentication_event.dart';
import 'package:crux/backend/blocs/authentication/authentication_state.dart';
import 'package:crux/backend/services/base_authentication_service.dart';
import 'package:crux/model/crux_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class BaseAuthMock extends Mock implements BaseAuthenticationService {}

class CruxUserMock extends Mock implements CruxUser {}

class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount {}

void main() {
  BaseAuthMock baseAuthMock;
  CruxUserMock cruxUserMock;
  GoogleSignInAccountMock googleSignInAccountMock;

  AuthenticationBloc authenticationBloc;

  setUp(() {
    baseAuthMock = BaseAuthMock();
    cruxUserMock = CruxUserMock();
    googleSignInAccountMock = GoogleSignInAccountMock();
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
        AuthenticationSuccess(cruxUser: cruxUserMock)
      ];

      when(baseAuthMock.signIn()).thenAnswer((_) => Future.value(cruxUserMock));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(GoogleSignInButtonTapped());
    });

    test('emits [uninitialized, inProgress, failure] when sign in fails', () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationInProgress(),
        AuthenticationFailure()
      ];

      when(baseAuthMock.signIn()).thenAnswer((_) => Future.value(null));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(GoogleSignInButtonTapped());
    });

    test('emits [uninitialized, inProgress, error] when sign in errors', () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationInProgress(),
        AuthenticationError()
      ];

      when(baseAuthMock.signIn())
          .thenAnswer((_) => Future.error(Exception('Google sign in test')));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(GoogleSignInButtonTapped());
    });
  });

  group('Google sign out', () {
    test('emits [uninitialized, inProgress, uninitialized] when sign out succeeds', () {
      final expectedResponse = [
        AuthenticationUninitialized(), // had to add this one as an initial state
        AuthenticationInProgress(),
        AuthenticationUninitialized(),
      ];

      when(baseAuthMock.signOut()).thenAnswer((_) => Future.value(cruxUserMock));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(AppBarSignOutButtonTapped(cruxUser: cruxUserMock));
    });

    test('emits [uninitialized, inProgress, failure] when sign out fails', () {
      final expectedResponse = [
        AuthenticationUninitialized(), // had to add this one as an initial state
        AuthenticationInProgress(),
        AuthenticationFailure(),
      ];

      when(baseAuthMock.signOut()).thenAnswer((_) => Future.value(null));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(AppBarSignOutButtonTapped(cruxUser: cruxUserMock));
    });

    test('emits [uninitialized, inProgress, error] when sign out errors', () {
      final expectedResponse = [
        AuthenticationUninitialized(), // had to add this one as an initial state
        AuthenticationInProgress(),
        AuthenticationError(),
      ];

      when(baseAuthMock.signOut()).thenAnswer((_) => Future.error('Unit test'));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(AppBarSignOutButtonTapped(cruxUser: cruxUserMock));
    });
  });

  group('Guest sign in', () {});

  group('Guest sign out', () {});
}
