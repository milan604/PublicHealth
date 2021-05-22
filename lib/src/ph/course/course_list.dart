import 'package:flutter/material.dart';
import 'package:PublicHealth/src/ph/models/articles.dart';
import 'package:PublicHealth/src/ph/models/videos.dart';
import 'package:PublicHealth/src/ph/bottom_navigation_view/bottom_bar_course_view.dart';
import 'package:PublicHealth/src/ph/models/course_tab_data.dart';
import 'package:PublicHealth/src/ph/course/mycourse_list.dart';

import 'package:PublicHealth/src/ph/course/download_course_screen.dart';
import '../ph_theme.dart';

class ListContent extends StatefulWidget {
  ListContent({Key key, this.animationController, this.label})
      : super(key: key);
  final String label;
  final AnimationController animationController;

  @override
  _ListContentState createState() => _ListContentState();
}

class _ListContentState extends State<ListContent>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  AnimationController animationController;
  // List<BookData> bookData = BookData.bookList;
  // List<SlideData> slideData = SlideData.slideList;
  List<ArticleData> articleData = ArticleData.articleList;
  List<VideoData> videoData = VideoData.videoList;
  List<Widget> listViews = <Widget>[];
  List data;
  String errorMessage;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List<CourseTabData> tabIconsList = CourseTabData.tabIconsList;
  Widget tabBody = Container(
    color: PHTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((CourseTabData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    tabBody = MyCourseScreen(
      animationController: animationController,
      label: widget.label,
    );

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
    super.initState();
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }
    String newString = string.toLowerCase();
    return newString[0].toUpperCase() + newString.substring(1);
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
            tabBody,
            bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarCourseView(
          tabIconsList: tabIconsList,
          category: widget.label,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = MyCourseScreen(
                    animationController: animationController,
                    label: widget.label,
                  );
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = DownloadCourseScreen(
                    animationController: animationController,
                    label: widget.label,
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
