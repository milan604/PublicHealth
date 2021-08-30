import 'package:flutter/material.dart';
import '../ph_theme.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';

final userRef = FirebaseFirestore.instance.collection("users");
final localAuth = LocalAuthentication();

class SettingsView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const SettingsView(
      {Key key,
      this.animationController,
      this.animation,
      this.currentUser,
      this.biometric})
      : super(key: key);
  final currentUser;
  final bool biometric;

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool biometricValid = false;
  @override
  void initState() {
    checkBiometric();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkBiometric() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    setState(() {
      biometricValid = canCheckBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: PHTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: PHTheme.grey.withOpacity(0.4),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 100,
                                          right: 16,
                                          top: 16,
                                        ),
                                        child: Text(
                                          "Fingerprint Setting",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: PHTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color: PHTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 100,
                                      bottom: 12,
                                      top: 4,
                                      right: 16,
                                    ),
                                    child: Text(
                                      "Turn on helps you to login by your fingerprint",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: PHTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        letterSpacing: 0.0,
                                        color: PHTheme.grey.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 115,
                                        right: 16,
                                        top: 10,
                                        bottom: 15,
                                      ),
                                      child: biometricValid
                                          ? _toggleBiometric(
                                              widget.currentUser["user_id"])
                                          : Text(
                                              "Sorry! Your Device Doesnot Support Biometric"),
                                    ),
                                  ]),
                                  // Column(children: <Widget>[
                                  //   Padding(
                                  //     padding: const EdgeInsets.only(
                                  //       left: 115,
                                  //       right: 16,
                                  //       top: 10,
                                  //       bottom: 15,
                                  //     ),
                                  //     child: Image.asset(
                                  //         "assets/images/ph/comingsoon.png"),
                                  //   ),
                                  // ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -16,
                        left: 0,
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Image.asset("assets/images/ph/biometric.png"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  addBiometricInfo(String userID, bool flag) async {
    DocumentSnapshot doc = await userRef.doc(userID).get();
    if (doc.exists) {
      userRef.doc(userID).update({
        "biometricEnabled": flag,
      });
      doc = await userRef.doc(userID).get();
    }
  }

  Widget _toggleBiometric(userID) {
    return LiteRollingSwitch(
      //initial value
      value: widget.biometric,
      textOn: 'ON',
      textOff: 'OFF',
      colorOn: Colors.greenAccent[700],
      colorOff: Colors.redAccent[700],
      iconOn: Icons.done,
      iconOff: Icons.remove_circle_outline,
      textSize: 15.0,
      onChanged: (bool state) {
        addBiometricInfo(userID, state);
      },
    );
  }
}
