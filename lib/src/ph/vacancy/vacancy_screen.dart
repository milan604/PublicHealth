import 'package:PublicHealth/src/ph/ui_view/wave_view.dart';
import 'package:PublicHealth/main.dart';
import 'package:PublicHealth/src/ph/ui_view/title_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PublicHealth/src/ph/models/vacancies.dart';

import '../ph_theme.dart';

class VacancyScreen extends StatefulWidget {
  const VacancyScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _VacancyScreenState createState() => _VacancyScreenState();
}

class _VacancyScreenState extends State<VacancyScreen>
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
    int itemCount = data.length;

    listViews.add(
      TitleView(
        titleTxt: 'All available vacancies ' + '(' + itemCount.toString() + ')',
        showIcon: false,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    for (int i = 0; i < itemCount; i++) {
      final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: widget.animationController,
          curve:
              Interval((1 / itemCount) * i, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );

      if (getDays(DateTime.now().toString(), data[i].endDate) <= 0) {
        continue;
      }
      listViews.add(
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      100 * (1.0 - animation.value), 0.0, 0.0),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        splashColor: PHTheme.nearlyDarkBlue,
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => SearchData(
                          //           animationController:
                          //               widget.animationController,
                          //           topicID: "test",
                          //           title: "test")),
                          // );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(30.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: HexColor("#FE95B6").withOpacity(0.6),
                                  offset: const Offset(1.1, 4.0),
                                  blurRadius: 8.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor("#43cea2"),
                                HexColor("#185a9d"),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data[i].title,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: "Deadline: ",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: data[i].endDate,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ]),
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: "Vacancy Period: ",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: getDays(data[i].startDate,
                                                        data[i].endDate)
                                                    .toString() +
                                                ' Days',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ]),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        data[i].description,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      )),
                                ],
                              )),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 8, top: 16),
                                    child: Container(
                                      width: 60,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        color: HexColor('#E8EDFE'),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(80.0),
                                            bottomLeft: Radius.circular(80.0),
                                            bottomRight: Radius.circular(80.0),
                                            topRight: Radius.circular(80.0)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color:
                                                  PHTheme.grey.withOpacity(0.4),
                                              offset: const Offset(2, 2),
                                              blurRadius: 4),
                                        ],
                                      ),
                                      child: WaveView(
                                        percentageValue: getPercentage(
                                            data[i].startDate, data[i].endDate),
                                        remainingDays: getDays(
                                            DateTime.now().toString(),
                                            data[i].endDate),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                ));
          },
        ),
      );
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
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
                                  'Vacancy',
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