import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ph_theme.dart';

final userRef = FirebaseFirestore.instance.collection("users");

class AccountView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const AccountView(
      {Key key, this.animationController, this.animation, this.currentUser})
      : super(key: key);

  final currentUser;

  @override
  Widget build(BuildContext context) {
    print(currentUser);
    String username = currentUser["display_name"];
    String email = currentUser["email"];

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
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
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                child: SizedBox(
                                  height: 74,
                                  child: AspectRatio(
                                    aspectRatio: 1.714,
                                    child: Image.asset(
                                        "assets/images/ph/back.png"),
                                  ),
                                ),
                              ),
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
                                          "Hi $username",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: PHTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
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
                                      "Welcome to PublicHealth App",
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
                                        left: 20,
                                        right: 16,
                                        top: 10,
                                        bottom: 15,
                                      ),
                                      child: Text(
                                        "Your Email : $email",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: PHTheme.fontName,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                          letterSpacing: 0.0,
                                          color: PHTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                  ]),
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
                          child: Image.asset("assets/images/ph/user.png"),
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
}
