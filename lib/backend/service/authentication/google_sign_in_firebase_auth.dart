import 'package:crux/backend/blocs/user/models/crux_user.dart';
import 'package:crux/backend/services/authentication/exceptions/sign_in_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'base_authentication_service.dart';

class GoogleSignInFirebaseAuth implements BaseAuthenticationService {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final CredentialManager credentialManager;

  GoogleSignInFirebaseAuth({
    @required this.googleSignIn,
    @required this.firebaseAuth,
    @required this.credentialManager,
  });

  /// Opens Google sign in overlay and signs user in with Google email. Using those credentials,
  /// connects that user to the Firebase instance for access to their Crux data.
  @override
  Future<CruxUser> signIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      if (null != googleSignInAccount) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = credentialManager.getCredentials(
            googleSignInAuthentication.accessToken, googleSignInAuthentication.idToken);

        AuthResult authResult = await firebaseAuth.signInWithCredential(authCredential);
        return CruxUser(
          displayName: authResult.user.displayName,
          email: authResult.user.email,
        );
      }
      print('Google sign in process aborted.');
      return null;
    } catch (error) {
      print('Error occurred signing in to Crux: ${error.toString()}');
      return Future.error(CruxSignInException());
    }
  }

  /// Signs out the current user (anonymous or not) from the Firebase instance and clears disk cache
  @override
  Future<CruxUser> signOut() async {
    try {
      await firebaseAuth.signOut();
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signOut();
      return CruxUser(
        displayName: googleSignInAccount.displayName,
        email: googleSignInAccount.email,
      );
    } catch (error) {
      print('Error occurred signing out of Crux: ${error.toString()}');
      return Future.error(CruxSignOutException());
    }
  }
}

class CredentialManager {
  AuthCredential getCredentials(String accessToken, String idToken) {
    return GoogleAuthProvider.getCredential(idToken: idToken, accessToken: accessToken);
  }
}
