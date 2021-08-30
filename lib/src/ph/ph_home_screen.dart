import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PublicHealth/src/ph/course/course_screen.dart';
import 'package:PublicHealth/src/ph/models/tabIcon_data.dart';
import 'package:PublicHealth/src/ph/profile/profile_screen.dart';
import 'package:PublicHealth/src/ph/vacancy/vacancy_screen.dart';
import 'package:flutter/material.dart';
import 'package:PublicHealth/src/services/authentication.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'ph_theme.dart';
import 'package:PublicHealth/src/ph/home/home_screen.dart';
import 'package:PublicHealth/src/ph/scholarship/scholarship_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:PublicHealth/src/ph/models/materials.dart';

final userRef = FirebaseFirestore.instance.collection("users");

class PHomeScreen extends StatefulWidget {
  PHomeScreen({Key key, this.title, this.auth, this.user, this.loginFrom})
      : super(key: key);
  final BaseAuth auth;
  final user;
  final String loginFrom;

  final String title;

  @override
  _PHomeScreenState createState() => _PHomeScreenState();
}

class _PHomeScreenState extends State<PHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Materials videoDta;
  String errorMessage;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: PHTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[4].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody =
        HomeScreen(animationController: animationController, user: widget.user);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PHTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ScholarshipScreen(
                    animationController: animationController,
                  );
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      CourseScreen(animationController: animationController);
                });
              });
            } else if (index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      VacancyScreen(animationController: animationController);
                });
              });
            } else if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ProfileScreen(
                      animationController: animationController,
                      auth: widget.auth,
                      user: widget.user,
                      loginFrom: widget.loginFrom);
                });
              });
            } else if (index == 4) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = HomeScreen(
                    animationController: animationController,
                    user: widget.user,
                  );
                });
              });
            }
          },
        ),
      ],
    );
  }
}
