import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/service/authentication/authentication_service.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_bloc.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_event.dart';
import 'package:crux/frontend/screen/authentication/bloc/authentication_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class BaseAuthMock extends Mock implements BaseAuthenticationService {}

class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount {}

void main() {
  BaseAuthMock baseAuthMock;
  final CruxUser cruxUser = CruxUser(uid: 'UID', displayName: 'Display Name', email: 'Email');

  AuthenticationBloc authenticationBloc;

  setUp(() {
    baseAuthMock = BaseAuthMock();
    authenticationBloc = AuthenticationBloc(authenticationService: baseAuthMock);
  });

  tearDown(() {
    authenticationBloc?.close();
  });

  test('initial state is correct', () {
    expect(authenticationBloc.state, AuthenticationUninitialized());
  });

  test('close does not emit new states', () {
    expectLater(
      authenticationBloc,
      emitsInOrder([emitsDone]),
    );
    authenticationBloc.close();
  });

  group('Google sign in', () {
    test('emits [inProgress, success] with FirebaseUser for normal sign in', () {
      final expectedResponse = [
        AuthenticationInProgress(),
        AuthenticationSuccess(cruxUser: cruxUser)
      ];

      when(baseAuthMock.signIn()).thenAnswer((_) => Future.value(cruxUser));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(GoogleSignInButtonTapped());
    });

    test('emits [inProgress, failure] when sign in fails', () {
      final expectedResponse = [
        AuthenticationInProgress(),
        AuthenticationFailure()
      ];

      when(baseAuthMock.signIn()).thenAnswer((_) => Future.value(null));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(GoogleSignInButtonTapped());
    });

    test('emits [inProgress, error] when sign in errors', () {
      final expectedResponse = [
        AuthenticationInProgress(),
        AuthenticationError()
      ];

      when(baseAuthMock.signIn()).thenAnswer((_) => Future.error(Exception('Google sign in test')));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(GoogleSignInButtonTapped());
    });
  });

  group('Google sign out', () {
    test('emits [inProgress, uninitialized] when sign out succeeds', () {
      final expectedResponse = [
        AuthenticationInProgress(),
        AuthenticationUninitialized(),
      ];

      when(baseAuthMock.signOut()).thenAnswer((_) => Future.value(cruxUser));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(AppBarSignOutButtonTapped(cruxUser: cruxUser));
    });

    test('emits [inProgress, failure] when sign out fails', () {
      final expectedResponse = [
        AuthenticationInProgress(),
        AuthenticationFailure(),
      ];

      when(baseAuthMock.signOut()).thenAnswer((_) => Future.value(null));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(AppBarSignOutButtonTapped(cruxUser: cruxUser));
    });

    test('emits [inProgress, error] when sign out errors', () {
      final expectedResponse = [
        AuthenticationInProgress(),
        AuthenticationError(),
      ];

      when(baseAuthMock.signOut()).thenAnswer((_) => Future.error('Google sign out test'));

      expectLater(authenticationBloc, emitsInOrder(expectedResponse));

      authenticationBloc.add(AppBarSignOutButtonTapped(cruxUser: cruxUser));
    });
  });

  group('Guest sign in', () {});

  group('Guest sign out', () {});
}
