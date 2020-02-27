import 'package:crux/backend/services/base_authentication_service.dart';
import 'package:crux/backend/services/google_sign_in_firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// Mock Definitions
class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class GoogleSignInMock extends Mock implements GoogleSignIn {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

class GoogleSignInAuthenticationMock extends Mock implements GoogleSignInAuthentication {}

class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount {}

class AuthResultMock extends Mock implements AuthResult {}

class CredentialManagerMock extends Mock implements CredentialManager {}

class AuthCredentialMock extends Mock implements AuthCredential {}

void main() {
  // Mocks
  final FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
  final GoogleSignInMock googleSignInMock = GoogleSignInMock();
  final FirebaseUserMock firebaseUserMock = FirebaseUserMock();
  final GoogleSignInAuthenticationMock googleSignInAuthenticationMock =
      GoogleSignInAuthenticationMock();
  final GoogleSignInAccountMock googleSignInAccountMock = GoogleSignInAccountMock();
  final AuthResultMock authResultMock = AuthResultMock();
  final CredentialManagerMock credentialManagerMock = CredentialManagerMock();
  final AuthCredentialMock authCredentialMock = AuthCredentialMock();

  // Subject
  final BaseAuthenticationService googleSignInFirebaseAuth = GoogleSignInFirebaseAuth(
    googleSignIn: googleSignInMock,
    firebaseAuth: firebaseAuthMock,
    credentialManager: credentialManagerMock,
  );

  group('Google Sign In with Firebase Auth', () {
    var accessToken = 'fakeAccessToken';
    var idToken = 'fakeIdToken';

    test('Given valid user signs in through Google, should return firebase user.', () async {
      // Sign in with google and get an account back
      when(googleSignInMock.signIn())
          .thenAnswer((_) => Future<GoogleSignInAccountMock>.value(googleSignInAccountMock));

      // Get OAuth2 access token authentication info for that account
      when(googleSignInAccountMock.authentication).thenAnswer(
          (_) => Future<GoogleSignInAuthenticationMock>.value(googleSignInAuthenticationMock));

      // Stub in auth tokens
      when(googleSignInAuthenticationMock.accessToken).thenReturn(accessToken);
      when(googleSignInAuthenticationMock.idToken).thenReturn(idToken);

      // Get credentials from credential manager to bypass static method call
      when(credentialManagerMock.getCredential(accessToken, idToken))
          .thenReturn(authCredentialMock);

      // Use those authentication credentials to sign in to firebase
      when(firebaseAuthMock.signInWithCredential(authCredentialMock))
          .thenAnswer((_) => Future<AuthResultMock>.value(authResultMock));

      // get firebase user from results
      when(authResultMock.user).thenReturn(firebaseUserMock);

      var actual = await googleSignInFirebaseAuth.signInWithGoogle();

      expect(actual, firebaseUserMock);
      verify(googleSignInMock.signIn()).called(1);
      verify(googleSignInAccountMock.authentication).called(1);
      verify(credentialManagerMock.getCredential(accessToken, idToken)).called(1);
      verify(firebaseAuthMock.signInWithCredential(authCredentialMock)).called(1);
    });

    test('Given invalid usern signs in through Google, should not return firebase user.', () async {
      when(googleSignInMock.signIn()).thenAnswer((_) => Future.value(null));

      var actual = await googleSignInFirebaseAuth.signInWithGoogle();
      expect(actual, null);
      verify(googleSignInMock.signIn()).called(1);
      verifyNever(googleSignInAccountMock.authentication);
      verifyNever(credentialManagerMock.getCredential(any, any));
      verifyNever(firebaseAuthMock.signInWithCredential(any));
    });

    test('Given error occurs signing in to Firebase, should not return firebase user.', () async {
      when(googleSignInMock.signIn())
          .thenAnswer((_) => Future<GoogleSignInAccountMock>.value(googleSignInAccountMock));

      when(googleSignInAccountMock.authentication).thenAnswer(
          (_) => Future<GoogleSignInAuthenticationMock>.value(googleSignInAuthenticationMock));

      when(googleSignInAuthenticationMock.accessToken).thenReturn(accessToken);
      when(googleSignInAuthenticationMock.idToken).thenReturn(idToken);

      when(credentialManagerMock.getCredential(accessToken, idToken))
          .thenReturn(authCredentialMock);

      when(firebaseAuthMock.signInWithCredential(authCredentialMock))
          .thenAnswer((_) => Future.error(Error()));

      var actual = await googleSignInFirebaseAuth.signInWithGoogle();
      expect(actual, null);
      verify(googleSignInMock.signIn()).called(1);
      verify(googleSignInAccountMock.authentication).called(1);
      verify(credentialManagerMock.getCredential(accessToken, idToken)).called(1);
      verify(firebaseAuthMock.signInWithCredential(authCredentialMock)).called(1);
    });
  });

  group('Google Sign Out with Firebase Auth', () {
    test(
        'Given user is currently signed in to Google and Firebase, should sign user out of both '
        'and should return Google account info.', () async {
      when(firebaseAuthMock.signOut()).thenAnswer((_) => Future<void>.value(null));

      when(googleSignInMock.signOut())
          .thenAnswer((_) => Future<GoogleSignInAccount>.value(googleSignInAccountMock));

      var actual = await googleSignInFirebaseAuth.signOutOfGoogle();

      expect(actual, googleSignInAccountMock);
      verify(firebaseAuthMock.signOut()).called(1);
      verify(googleSignInMock.signOut()).called(1);
    });

    test(
        'Given user is currently signed in to Google and Firebase and Firebase sign out fails, '
        'should not sign user out of either and should return null Google account info.', () async {
      when(firebaseAuthMock.signOut()).thenAnswer((_) => Future.error(Error()));

      var actual = await googleSignInFirebaseAuth.signOutOfGoogle();

      expect(actual, null);
      verify(firebaseAuthMock.signOut()).called(1);
      verifyNever(googleSignInMock.signOut());
    });

    test(
        'Given user is currently signed in to Google and Firebase and Google sign out fails, '
        'should not sign user out of Google and should return null Google account info.', () async {
      when(firebaseAuthMock.signOut()).thenAnswer((_) => Future<void>.value(null));

      when(googleSignInMock.signOut())
          .thenAnswer((_) => Future<GoogleSignInAccount>.error(Error()));

      var actual = await googleSignInFirebaseAuth.signOutOfGoogle();

      expect(actual, null);
      verify(firebaseAuthMock.signOut()).called(1);
      verify(googleSignInMock.signOut()).called(1);
    });
  });
}
