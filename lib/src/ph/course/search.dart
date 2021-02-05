import 'package:flutter/material.dart';
import 'package:PublicHealth/src/ph/models/materials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../main.dart';
import '../ph_theme.dart';

class SearchData extends StatefulWidget {
  SearchData({Key key, this.topicID, this.title, this.animationController})
      : super(key: key);
  final String topicID;
  final String title;
  final AnimationController animationController;

  @override
  _SearchDataState createState() => _SearchDataState();
}

class _SearchDataState extends State<SearchData> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  AnimationController animationController;
  List materials;
  List items = List();
  String errorMessage;
  TextEditingController editingController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    getMaterials();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

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

  getMaterials() {
    CollectionReference materialRef =
        FirebaseFirestore.instance.collection("materials");
    materialRef.where('TypeID', isEqualTo: widget.topicID).snapshots().listen(
        (event) {
      if (event != null) {
        setState(() {
          materials =
              event.docs.map((e) => Materials.fromFirestore(e)).toList();
          items = List();
        });
        items.addAll(materials);
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
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      child: TextField(
        onChanged: (value) {
          filterSearchResults(value);
        },
        controller: editingController,
        decoration: InputDecoration(
            labelText: widget.title,
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List searchedList = List();
      materials.forEach((book) {
        if (book.title.contains(query) || book.author.contains(query)) {
          searchedList.add(book);
        }
      });
      setState(() {
        items.clear();
        items.addAll(searchedList);
      });
    } else {
      setState(() {
        items.clear();
        items.addAll(materials);
      });
    }
  }

  Widget getMainListViewUI() {
    return Container(
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.only(
          top: AppBar().preferredSize.height +
              MediaQuery.of(context).padding.top +
              24,
          bottom: 62 + MediaQuery.of(context).padding.bottom,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / items.length) * index, 1.0,
                  curve: Curves.fastOutSlowIn),
            ),
          );
          animationController.forward();
          return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        200 * (1.0 - animation.value), 0.0, 0.0),
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(30.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: HexColor(items[index].endColor)
                                      .withOpacity(0.6),
                                  offset: const Offset(1.1, 4.0),
                                  blurRadius: 8.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor(items[index].startColor),
                                HexColor(items[index].endColor),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${items[index].title}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'popins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    items[index].author.toString().isNotEmpty
                                        ? Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          )
                                        : Icon(null),
                                    Text(
                                      '${items[index].author}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'popins',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ));
            },
          );
        },
      ),
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
                      bottomLeft: Radius.circular(42.0),
                      bottomRight: Radius.circular(42.0),
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
                              child: searchBar(),
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
