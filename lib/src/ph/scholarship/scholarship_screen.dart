import 'package:PublicHealth/main.dart';
import 'package:PublicHealth/src/ph/ui_view/title_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PublicHealth/src/ph/models/scholarships.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

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
    getScholarship();

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

  getScholarship() {
    Query scholarRef = FirebaseFirestore.instance
        .collection("scholarship")
        .orderBy("StartDateTime");

    scholarRef.snapshots().listen((event) {
      if (event != null) {
        if (this.mounted) {
          setState(() {
            data =
                event.docs.map((e) => Scholarships.fromFirestore(e)).toList();
            listViews = <Widget>[];
          });
        }
        addAllListData(data);
      }
    }, onError: (e) {
      setState(() {
        errorMessage = e.toString();
      });
    });
  }

  String extractDate(DateTime time) {
    var format = DateFormat.yMMMEd();
    var date = format.format(time);
    return date;
  }

  void addAllListData(List data) {
    const int count = 5;
    listViews.clear();
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

    var groupedData = {};
    data.forEach((element) {
      var date = extractDate(DateTime.parse(element.startDate));
      var newStartDate = DateTime.parse(element.startDate);
      var endDate = DateTime.parse(element.endDate);
      var currentDate = new DateTime.now().subtract(Duration(days: 1));
      var current = new DateTime.now();
      var newEndDate = element.endDate;
      if (element.recurring) {
        date = current.year.toString() +
            "-" +
            newStartDate.month.toString() +
            "-" +
            newStartDate.day.toString();
        newEndDate = current.year.toString() +
            "-" +
            endDate.month.toString() +
            "-" +
            endDate.day.toString();
      }
      var payload = {
        "description": element.description,
        "title": element.title,
        "startDate": date,
        "endDate": newEndDate,
        "issuer": element.issuer,
        "post": element.post,
        "location": element.location,
        "link": element.link,
      };

      if (endDate.isAfter(currentDate)) {
        if (groupedData[date] == null) {
          groupedData[date] = [payload];
        } else {
          var arr = groupedData[date];
          arr.add(payload);
          groupedData[date] = arr;
        }
      }
    });

    int itemCount = groupedData.length;
    final children = <Widget>[];
    int i = 0;
    groupedData.forEach((key, value) {
      var date = key;
      if (i == 0) {
        children.add(TimelineTile(
          alignment: TimelineAlign.center,
          lineXY: 0.1,
          isFirst: true,
          indicatorStyle: const IndicatorStyle(
            width: 20,
            color: Colors.orange,
          ),
          beforeLineStyle: const LineStyle(
            color: Colors.orange,
            thickness: 6,
          ),
        ));
      }
      if (checkEven(i + 1) == false) {
        if (i != 0) {
          children.add(TimelineDivider(
            axis: TimelineAxis.horizontal,
            begin: 0.5,
            end: 0.99,
            thickness: 6,
            color: Colors.orange,
          ));
        }
        children.add(TimelineTile(
          alignment: TimelineAlign.center,
          lineXY: 0.001,
          beforeLineStyle: const LineStyle(
            color: Colors.orange,
            thickness: 6,
          ),
          afterLineStyle: const LineStyle(
            color: Colors.orange,
            thickness: 6,
          ),
          indicatorStyle: IndicatorStyle(
            indicator: dateBox(date.toString(), true),
            indicatorXY: 1,
            width: 120,
            height: 40,
            color: Colors.orange,
          ),
        ));
        children.add(TimelineTile(
            alignment: TimelineAlign.center,
            lineXY: 0.001,
            beforeLineStyle: const LineStyle(
              color: Colors.orange,
              thickness: 6,
            ),
            afterLineStyle: const LineStyle(
              color: Colors.orange,
              thickness: 6,
            ),
            indicatorStyle: IndicatorStyle(
              indicatorXY: 0.01,
              width: 5,
              color: Colors.orange,
            ),
            startChild: scholarshipList(value, true)));
      } else {
        children.add(TimelineDivider(
          axis: TimelineAxis.horizontal,
          begin: 0.01,
          end: 0.5,
          thickness: 6,
          color: Colors.orange,
        ));
        children.add(TimelineTile(
          alignment: TimelineAlign.center,
          lineXY: 0.0001,
          beforeLineStyle: const LineStyle(
            color: Colors.orange,
            thickness: 6,
          ),
          afterLineStyle: const LineStyle(
            color: Colors.orange,
            thickness: 6,
          ),
          indicatorStyle: IndicatorStyle(
            indicator: dateBox(date.toString(), false),
            indicatorXY: 1,
            width: 120,
            height: 40,
            color: Colors.orange,
          ),
        ));
        children.add(TimelineTile(
            alignment: TimelineAlign.center,
            lineXY: 0.001,
            beforeLineStyle: const LineStyle(
              color: Colors.orange,
              thickness: 6,
            ),
            afterLineStyle: const LineStyle(
              color: Colors.orange,
              thickness: 6,
            ),
            indicatorStyle: IndicatorStyle(
              indicatorXY: 0.01,
              width: 5,
              color: Colors.orange,
            ),
            endChild: scholarshipList(value, false)));
      }

      if (i == (itemCount - 1)) {
        if (checkEven(itemCount - 1)) {
          children.add(TimelineDivider(
            axis: TimelineAxis.horizontal,
            begin: 0.01,
            end: 0.5,
            thickness: 6,
            color: Colors.orange,
          ));
        } else {
          children.add(TimelineDivider(
            axis: TimelineAxis.horizontal,
            begin: 0.5,
            end: 0.99,
            thickness: 6,
            color: Colors.orange,
          ));
        }
        children.add(TimelineTile(
          alignment: TimelineAlign.center,
          lineXY: 0.1,
          isLast: true,
          beforeLineStyle: const LineStyle(
            color: Colors.orange,
            thickness: 6,
          ),
          indicatorStyle: const IndicatorStyle(
            width: 20,
            color: Colors.orange,
          ),
        ));
      }

      i++;
    });

    listViews.add(Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    ));
  }

  bool checkEven(num) {
    if (num % 2 == 0) {
      return true;
    }
    return false;
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Widget scholarshipList(List data, bool flag) {
    final children = <Widget>[];
    data.forEach((element) {
      children.add(Container(
          padding: EdgeInsets.all(5),
          width: 200,
          child: InkWell(
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              splashColor: PHTheme.nearlyDarkBlue,
              onTap: () {
                showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) => bottomModal(element),
                );
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: flag
                        ? BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0))
                        : BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(20.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: HexColor("#FA7D82").withOpacity(0.6),
                          offset: const Offset(1.1, 4.0),
                          blurRadius: 8.0),
                    ],
                    gradient: LinearGradient(
                      colors: <HexColor>[
                        HexColor("#FFB295"),
                        HexColor("#FA7D82"),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            element["title"],
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'popins',
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      )),
                    ],
                  )))));
    });
    return Container(
      padding: EdgeInsets.only(left: 20, top: 40),
      alignment: Alignment.center,
      child: Column(
        children: children,
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget bottomModal(data) {
    return Container(
        decoration: BoxDecoration(color: PHTheme.nearlyBlack),
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Text(
                      "Scholarship Title",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data["title"],
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white70,
                          fontFamily: PHTheme.fontName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data["description"],
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white70,
                          fontFamily: PHTheme.fontName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Location",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data["location"],
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white70,
                          fontFamily: PHTheme.fontName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Application Submission Start Date",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data["startDate"],
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white70,
                          fontFamily: PHTheme.fontName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Application Submission Deadline",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data["endDate"],
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white70,
                          fontFamily: PHTheme.fontName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Scolarship for Program",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data["post"],
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white70,
                          fontFamily: PHTheme.fontName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Scholarship Issuer",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data["issuer"],
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white70,
                          fontFamily: PHTheme.fontName,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            _launchURL(data["link"]);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              'Go To the Original Page',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: "Poppins"),
                            ),
                          ),
                        )),
                  ],
                ),
                Visibility(
                    visible: false,
                    child: Container(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.arrow_downward_rounded,
                                color: Colors.blue, size: 40),
                            onPressed: () {})))
              ],
            )));
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
                      top: BorderSide(width: 3, color: Colors.orange))
                  : Border(
                      bottom: BorderSide(width: 3, color: Colors.orange),
                      left: BorderSide(width: 4, color: Colors.orange),
                      top: BorderSide(width: 3, color: Colors.orange),
                      right: BorderSide(width: 1, color: Colors.orange)),
            ),
            child: Text(
              date,
              style: TextStyle(
                  fontSize: 13,
                  color: HexColor("#1313af"),
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
                  padding: EdgeInsets.all(5.0), child: listViews[index]);
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
                                    'Timeline',
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
