import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/services.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> onAuthStateChanged() {
    return _auth.onAuthStateChanged;
  }

  Future<FirebaseUser> getCurrentUser() async {
    final user = await _auth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }

  Future<AuthResult> signIn(
      {@required String email, @required String password}) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _auth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final updateUser = UserUpdateInfo();
          updateUser.displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(updateUser);
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        print(result.error.toString());
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

  Future<void> resetPassword({@required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<AuthResult> createUser(
      {@required String email, @required String password}) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> deleteCurrentlyLoggedInUser() async {
    try {
      final user = await _auth.currentUser();
      // this also signs out the user
      await user.delete();
    } catch (e) {
      print('Isaak could not delete the user');
      print(e);
    }
  }
}
