import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:PublicHealth/src/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:PublicHealth/src/ph/ph_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PublicHealth/src/services/tokenGen.dart';

final userRef = FirebaseFirestore.instance.collection("users");
final userTokenRef = FirebaseFirestore.instance.collection("user_tokens");
final DateTime timestamp = DateTime.now();

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User user;

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _googleLoginButton() {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            widget.auth.signInGoogle().then((user) => {
                  createUserFirestore(user.uid, user.displayName, user.email),
                  createUserToken(user.uid),
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => PHomeScreen(
                              auth: widget.auth,
                              user: user,
                              loginFrom: "google")))
                });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 13),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              'Login with Google',
              style: TextStyle(
                  fontSize: 20, color: Colors.white, fontFamily: "Poppins"),
            ),
          ),
        ));
  }

  Widget _fbLoginButton() {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            widget.auth.facebookLogin().then((user) => {
                  createUserFirestore(user.uid, user.displayName, user.email),
                  createUserToken(user.uid),
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => PHomeScreen(
                              auth: widget.auth, user: user, loginFrom: "fb")))
                });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 13),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              'Login with Facebook',
              style: TextStyle(
                  fontSize: 20, color: Colors.white, fontFamily: "Poppins"),
            ),
          ),
        ));
  }

  createUserFirestore(userId, username, email) async {
    DocumentSnapshot doc = await userRef.doc(userId).get();
    if (!doc.exists) {
      userRef.doc(userId).set({
        "id": userId,
        "isAdmin": false,
        "username": username,
        "email": email,
        "timestamp": timestamp
      });
      doc = await userRef.doc(userId).get();
    }
  }

  createUserToken(userId) async {
    var token = generateToken(userId);
    DocumentSnapshot doc = await userTokenRef.doc(userId).get();
    if (!doc.exists) {
      userTokenRef.doc(userId).set({"user_id": userId, "token": token});
      doc = await userRef.doc(userId).get();
    } else {
      userTokenRef.doc(userId).update({"user_id": userId, "token": token});
      doc = await userRef.doc(userId).get();
    }
  }

  Widget _title() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'P',
                style: GoogleFonts.portLligatSans(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: 'UBLI',
                    style: TextStyle(color: Colors.black, fontSize: 40),
                  ),
                  TextSpan(
                    text: 'C Health',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ]),
          ),
          Image.asset(
            "assets/images/pub_logo.png",
            width: 200,
            height: 200,
          ),
        ],
      ),
    );
  }

  Widget _rootPage(height) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xfffbb448), Color(0xffe46b10)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              _title(),
              SizedBox(
                height: 80,
              ),
              _googleLoginButton(),
              SizedBox(
                height: 20,
              ),
              _fbLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _rootPage(MediaQuery.of(context).size.height);
        } else {
          return _rootPage(null);
        }
      },
    );
  }
}
