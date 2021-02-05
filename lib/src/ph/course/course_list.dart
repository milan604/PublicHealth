import 'package:flutter/material.dart';
import 'package:PublicHealth/src/ph/course/search.dart';
import 'package:PublicHealth/src/ph/models/articles.dart';
import 'package:PublicHealth/src/ph/models/books.dart';
import 'package:PublicHealth/src/ph/models/slides.dart';
import 'package:PublicHealth/src/ph/models/videos.dart';
import 'package:PublicHealth/src/ph/ui_view/title_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../main.dart';
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

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    switch (widget.label) {
      case "BOOKS":
        {
          getBooks();
        }
        break;

      case "SLIDES":
        {
          getSlides();
        }
        break;
      case "ARTICLES":
        {
          getArticles();
        }
        break;
      case "VIDEOS":
        {
          getVideos();
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }

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

  getBooks() {
    CollectionReference bookRef =
        FirebaseFirestore.instance.collection("books");

    bookRef.snapshots().listen((event) {
      if (event != null) {
        setState(() {
          data = event.docs.map((e) => BookData.fromFirestore(e)).toList();
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

  getSlides() {
    CollectionReference slideRef =
        FirebaseFirestore.instance.collection("slides");

    slideRef.snapshots().listen((event) {
      if (event != null) {
        setState(() {
          data = event.docs.map((e) => SlideData.fromFirestore(e)).toList();
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

  getArticles() {
    CollectionReference articleRef =
        FirebaseFirestore.instance.collection("articles");

    articleRef.snapshots().listen((event) {
      if (event != null) {
        setState(() {
          data = event.docs.map((e) => SlideData.fromFirestore(e)).toList();
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

  getVideos() {
    CollectionReference videoRef =
        FirebaseFirestore.instance.collection("videos");

    videoRef.snapshots().listen((event) {
      if (event != null) {
        setState(() {
          data = event.docs.map((e) => SlideData.fromFirestore(e)).toList();
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

  void addAllListData(List data) {
    const int count = 5;
    int itemCount = data.length;

    listViews.add(
      TitleView(
        titleTxt: 'Available ' +
            capitalize(widget.label) +
            ' (' +
            itemCount.toString() +
            ')',
        showIcon: false,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    // TODO implement the case for no data
    for (int i = 0; i < itemCount; i++) {
      final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve:
              Interval((1 / data.length) * i, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );
      listViews.add(
        AnimatedBuilder(
          animation: animationController,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchData(
                                    animationController: animationController,
                                    topicID: data[i].id,
                                    title: data[i].title)),
                          );
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
                                  color: HexColor(data[i].endColor)
                                      .withOpacity(0.6),
                                  offset: const Offset(1.1, 4.0),
                                  blurRadius: 8.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor(data[i].startColor),
                                HexColor(data[i].endColor),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
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
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        data[i].description,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      )),
                                ],
                              )),
                              Row(
                                children: <Widget>[
                                  Text(
                                    data[i].rating.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
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
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              animationController.forward();
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
                                  widget.label,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    capitalize(widget.label) + " Category",
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
