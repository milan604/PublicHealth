import 'package:PublicHealth/main.dart';
import 'package:PublicHealth/src/ph/ui_view/title_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PublicHealth/src/ph/models/vacancies.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../ph_theme.dart';

class ScholarshipScreen extends StatefulWidget {
  const ScholarshipScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;
  @override
  _ScholarshipScreenState createState() => _ScholarshipScreenState();
}

class _ScholarshipScreenState extends State<ScholarshipScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  List data;
  String errorMessage;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    getVacancy();

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

  getVacancy() {
    CollectionReference videoRef =
        FirebaseFirestore.instance.collection("vacancies");

    videoRef.snapshots().listen((event) {
      if (event != null) {
        setState(() {
          data = event.docs.map((e) => Vacancies.fromFirestore(e)).toList();
          listViews = <Widget>[];
        });
        addAllListData(data);
      }
    }, onError: (e) {
      setState(() {
        errorMessage = e.toString();
      });
    });
  }

  getDays(startDate, endDate) {
    var date = DateTime.parse(endDate);
    var sDate = DateTime.parse(startDate);

    return date.difference(sDate).inDays;
  }

  getPercentage(startDate, endDate) {
    var currentDate = DateTime.now();
    var totaldays = getDays(startDate, endDate);
    var remainingDays = getDays(currentDate.toString(), endDate);

    var percentage = remainingDays / totaldays * 100.0;
    return percentage;
  }

  void addAllListData(List data) {
    const int count = 5;

    listViews.add(
      TitleView(
        titleTxt: 'Scholarship Timeline ' +
            '(' +
            DateTime.now().year.toString() +
            ')',
        showIcon: false,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    // for (int i = 0; i < itemCount; i++) {
    //   final Animation<double> animation =
    //       Tween<double>(begin: 0.0, end: 1.0).animate(
    //     CurvedAnimation(
    //       parent: widget.animationController,
    //       curve:
    //           Interval((1 / itemCount) * i, 1.0, curve: Curves.fastOutSlowIn),
    //     ),
    //   );

    listViews.add(Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TimelineTile(
            alignment: TimelineAlign.center,
            lineXY: 0.1,
            isFirst: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Colors.green,
            ),
            beforeLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
          ),
          TimelineDivider(
            axis: TimelineAxis.horizontal,
            begin: 0.01,
            end: 0.5,
            thickness: 6,
            color: Colors.orange,
          ),
          TimelineTile(
            alignment: TimelineAlign.center,
            lineXY: 0.001,
            beforeLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
            afterLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
            indicatorStyle: IndicatorStyle(
              indicator: dateBox("Sep 04, 2021", true),
              indicatorXY: 0.001,
              width: 150,
              height: 40,
              color: Colors.green,
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.center,
            lineXY: 0.5,
            beforeLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
            afterLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
            indicatorStyle: IndicatorStyle(
              indicatorXY: 0.01,
              width: 5,
              color: Colors.green,
            ),
          ),
          TimelineDivider(
            axis: TimelineAxis.horizontal,
            begin: 0.5,
            end: 0.99,
            thickness: 6,
            color: Colors.orange,
          ),
          TimelineTile(
            alignment: TimelineAlign.center,
            lineXY: 0.5,
            beforeLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
            afterLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
            indicatorStyle: IndicatorStyle(
              indicator: dateBox("Dec 20, 2021", false),
              indicatorXY: 0.001,
              width: 150,
              height: 40,
              color: Colors.green,
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.center,
            lineXY: 0.5,
            beforeLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
            afterLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
            indicatorStyle: IndicatorStyle(
              width: 5,
              color: Colors.green,
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.center,
            lineXY: 0.1,
            isLast: true,
            beforeLineStyle: const LineStyle(
              color: Colors.green,
              thickness: 6,
            ),
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Colors.green,
            ),
          ),
        ],
      ),
    ));
    // }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Widget dateBox(String date, bool flag) {
    return Material(
        color: HexColor("#F2F3F8"),
        // color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.all(Radius.circular(5)),
              // border: Border.all(color: Colors.orange, width: 6),
              border: flag
                  ? Border(
                      bottom: BorderSide(width: 3, color: Colors.orange),
                      right: BorderSide(width: 4, color: Colors.orange),
                      left: BorderSide(width: 1, color: Colors.orange),
                      top: BorderSide(width: 1, color: Colors.orange))
                  : Border(
                      bottom: BorderSide(width: 3, color: Colors.orange),
                      left: BorderSide(width: 4, color: Colors.orange),
                      top: BorderSide(width: 1, color: Colors.orange),
                      right: BorderSide(width: 1, color: Colors.orange)),
            ),
            child: Text(
              date,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.purple,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
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
              bottom: 60 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return Container(
                  padding: EdgeInsets.all(15.0), child: listViews[index]);
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
                                  'Scholarship',
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
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_left,
                            //         color: PHTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 8),
                                  //   child: Icon(
                                  //     Icons.calendar_today,
                                  //     color: PHTheme.grey,
                                  //     size: 18,
                                  //   ),
                                  // ),
                                  Text(
                                    'Job Vacancies',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: PHTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: PHTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_right,
                            //         color: PHTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
