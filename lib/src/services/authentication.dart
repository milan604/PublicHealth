import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart' as fl;

abstract class BaseAuth {
  Future<User> signInGoogle();

  Future signOutGoogle();

  Future<User> facebookLogin();

  Future signOutFacebook();

  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<User> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final fl.FacebookLogin fbLogin = new fl.FacebookLogin();

  Future<User> signInGoogle() async {
    final user = await _googleSignIn.signIn();
    final googleAuth = await user.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final loginUser = authResult.user;

    assert(!loginUser.isAnonymous);
    assert(await loginUser.getIdToken() != null);

    final currentUser = _firebaseAuth.currentUser;
    assert(currentUser.uid == loginUser.uid);

    return loginUser;
  }

  Future signOutGoogle() async {
    await _googleSignIn.disconnect();
    _firebaseAuth.signOut();
  }

  Future<User> facebookLogin() async {
    User currentUser;
    // fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // if you remove above comment then facebook login will take username and pasword for login in Webview
    try {
      final fl.FacebookLoginResult facebookLoginResult =
          await fbLogin.logIn(['email', 'public_profile']);
      if (facebookLoginResult.status == fl.FacebookLoginStatus.loggedIn) {
        fl.FacebookAccessToken facebookAccessToken =
            facebookLoginResult.accessToken;
        final AuthCredential credential =
            FacebookAuthProvider.credential(facebookAccessToken.token);
        final User user =
            (await _firebaseAuth.signInWithCredential(credential)).user;
        assert(user.email != null);
        assert(user.displayName != null);
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        currentUser = _firebaseAuth.currentUser;
        assert(user.uid == currentUser.uid);
        return currentUser;
      }
    } catch (e) {
      print(e);
    }

    return currentUser;
  }

  Future signOutFacebook() async {
    await fbLogin.logOut();
    _firebaseAuth.signOut();
  }

  Future<String> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  Future<User> getCurrentUser() async {
    User user = _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }
}
