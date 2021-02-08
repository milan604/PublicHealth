import 'package:PublicHealth/src/ph/ph_theme.dart';
import 'package:flutter/material.dart';
import 'package:PublicHealth/src/ph/course/course_list.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final bool showIcon;
  final AnimationController animationController;
  final Animation animation;

  const TitleView(
      {Key key,
      this.titleTxt: "",
      this.subTxt: "",
      this.showIcon: false,
      this.animationController,
      this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        titleTxt,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: PHTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: PHTheme.lightText,
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      onTap: () {
                        if (titleTxt == "Video Lesson") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListContent(
                                    animationController: animationController,
                                    label: "VIDEOS")),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              subTxt,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: PHTheme.fontName,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                letterSpacing: 0.5,
                                color: PHTheme.nearlyDarkBlue,
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 26,
                              child: Icon(
                                Icons.arrow_forward,
                                color: showIcon
                                    ? PHTheme.darkText
                                    : Color(0xffF4F4F9),
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
