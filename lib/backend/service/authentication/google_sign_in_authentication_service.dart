import 'dart:async';
import 'dart:developer';

import 'package:crux/backend/repository/user/model/crux_user.dart';
import 'package:crux/backend/service/authentication/exception/sign_in_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authentication_service.dart';

class GoogleSignInAuthenticationService implements BaseAuthenticationService {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final CredentialManager credentialManager;

  GoogleSignInAuthenticationService({
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
          uid: authResult.user.uid,
          displayName: authResult.user.displayName,
          email: authResult.user.email,
        );
      }
      log('Google sign in process aborted.');
      return null;
    } catch (error) {
      log('Error occurred signing in to Crux', error: error);
      throw CruxSignInException();
    }
  }

  /// Signs out the current user (anonymous or not) from the Firebase instance and clears disk cache
  @override
  Future<CruxUser> signOut() async {
    try {
      await firebaseAuth.signOut();
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signOut();
      return CruxUser(
        uid: null,
        displayName: googleSignInAccount.displayName,
        email: googleSignInAccount.email,
      );
    } catch (error) {
      log('Error occurred signing out of Crux', error: error);
      throw CruxSignOutException();
    }
  }
}

class CredentialManager {
  AuthCredential getCredentials(String accessToken, String idToken) {
    return GoogleAuthProvider.getCredential(idToken: idToken, accessToken: accessToken);
  }
}
