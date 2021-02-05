import 'package:flutter/material.dart';
import 'package:PublicHealth/src/ph/course/course_screen.dart';
import 'package:PublicHealth/src/ph/test/test_screen.dart';

import '../ph_theme.dart';

class HomeListView extends StatefulWidget {
  const HomeListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  @override
  _HomeListViewState createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<String> areaListData = <String>[
    'assets/images/study.png',
    'assets/images/practice.png',
    'assets/images/test.png',
    'assets/images/news.png',
  ];
  List<String> areaListLabel = <String>[
    'STUDY',
    'PRACTICE',
    'TEST',
    'NEWS',
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: List<Widget>.generate(
                    areaListData.length,
                    (int index) {
                      final int count = areaListData.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController.forward();
                      return AreaView(
                        imagepath: areaListData[index],
                        label: areaListLabel[index],
                        animation: animation,
                        animationController: animationController,
                      );
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    Key key,
    this.imagepath,
    this.label,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final String imagepath;
  final String label;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: PHTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: PHTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: PHTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {
                    switch (label) {
                      case "STUDY":
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CourseScreen(
                                    animationController: animationController)),
                          );
                        }
                        break;

                      case "PRACTICE":
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TestScreen(
                                    animationController: animationController)),
                          );
                        }
                        break;

                      case "TEST":
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TestScreen(
                                    animationController: animationController)),
                          );
                        }
                        break;

                      case "NEWS":
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CourseScreen(
                                    animationController: animationController)),
                          );
                        }
                        break;

                      default:
                        {
                          print("Invalid Label");
                        }
                        break;
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Image.asset(
                          imagepath,
                          height: 110,
                          width: 100,
                        ),
                      ),
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Adobe Clean',
                          fontSize: 15,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
