import 'package:flutter/cupertino.dart';
import 'package:PublicHealth/src/ph/ui_view/settings_view.dart';
import 'package:PublicHealth/src/ph/ui_view/account_view.dart';
import 'package:PublicHealth/src/ph/ui_view/logout_view.dart';
import 'package:PublicHealth/src/ph/ui_view/profile_title_view.dart';
import 'package:flutter/material.dart';
import 'package:PublicHealth/src/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../login.dart';
import '../ph_theme.dart';

final userRef = FirebaseFirestore.instance.collection("users");
final userTokenRef = FirebaseFirestore.instance.collection("user_tokens");

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {Key key, this.animationController, this.auth, this.user, this.loginFrom})
      : super(key: key);

  final AnimationController animationController;
  final BaseAuth auth;
  final user;
  final String loginFrom;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> proflistViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool biometric = false;

  signOut() async {
    print(widget.loginFrom);
    try {
      if (widget.loginFrom == "fb") {
        await widget.auth.signOutFacebook();
      } else {
        await widget.auth.signOutGoogle();
      }
      resetUserInSharedPreferesces();
      removeUserToken(widget.user["user_id"]);
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => LoginPage(auth: new Auth())),
          (Route<dynamic> route) => false);
    } catch (e) {
      print(e);
    }
  }

  readUserInfo(String userID) {
    userRef.doc(userID).get().then((doc) => {
          setState(() {
            biometric = doc.data()["biometricEnabled"];
            proflistViews = <Widget>[];
          }),
          addAllListData(biometric),
        });
  }

  resetUserInSharedPreferesces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", "");
    await prefs.setString("display_name", "");
    await prefs.setString("photo_url", "");
    await prefs.setString("email", "");
    await prefs.setString("source", "");
  }

  removeUserToken(userId) async {
    DocumentSnapshot doc = await userTokenRef.doc(userId).get();
    if (doc.exists) {
      userTokenRef.doc(userId).set({"user_id": userId, "token": ""});
      doc = await userTokenRef.doc(userId).get();
    }
  }

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    readUserInfo(widget.user["user_id"]);

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    readUserInfo(widget.user["user_id"]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addAllListData(biometric) {
    const int count = 5;
    proflistViews.clear();
    proflistViews.add(
      ProfileTitleView(
        titleTxt: 'Account',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    proflistViews.add(
      AccountView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        currentUser: widget.user,
      ),
    );

    proflistViews.add(
      ProfileTitleView(
        titleTxt: 'Biometric Settings',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    proflistViews.add(
      SettingsView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        currentUser: widget.user,
        biometric: biometric,
      ),
    );

    proflistViews.add(
      ProfileTitleView(
        titleTxt: 'Logout',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    proflistViews.add(
      LogoutView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        logout: signOut,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PHTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: proflistViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return proflistViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: PHTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: PHTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Profile',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: PHTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: PHTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
