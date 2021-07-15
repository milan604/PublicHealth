import 'package:PublicHealth/main.dart';
import 'package:PublicHealth/src/ph/ui_view/title_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PublicHealth/src/ph/models/videos.dart';
import 'package:PublicHealth/src/ph/models/articles.dart';
import 'package:PublicHealth/src/globals.dart' as globals;
import 'package:PublicHealth/src/ph/models/materials.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

import '../ph_theme.dart';

final userRef = FirebaseFirestore.instance.collection("users");
final materialRef = FirebaseFirestore.instance.collection("materials");

class MyCourseScreen extends StatefulWidget {
  const MyCourseScreen({Key key, this.animationController, this.label})
      : super(key: key);

  final AnimationController animationController;
  final String label;
  @override
  _MyCourseScreenState createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  AnimationController animationController;
  List data;
  String errorMessage;
  List userMaterials = [];
  List materials;
  List items = [];
  String _version = 'Unknown';

  List<ArticleData> articleData = ArticleData.articleList;
  List<VideoData> videoData = VideoData.videoList;

  List<Widget> myDownloadedListViews = <Widget>[];
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
    readUserFirestore(globals.userID);
    initPlatformState();

    super.initState();
  }

  Future<void> initPlatformState() async {
    String version;
    try {
      PdftronFlutter.initialize('');
      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _version = version;
    });
  }

  getMaterials() {
    CollectionReference materialRef =
        FirebaseFirestore.instance.collection("materials");
    materialRef
        .where('Type', isEqualTo: widget.label.toLowerCase())
        .snapshots()
        .listen((event) {
      if (event != null) {
        setState(() {
          materials =
              event.docs.map((e) => Materials.fromFirestore(e)).toList();
        });
        addAllListData(filterMaterials(materials));
      }
    }, onError: (e) {
      setState(() {
        errorMessage = e.toString();
      });
    });
  }

  readUserFirestore(userId) async {
    await userRef.doc(userId).get().then((value) => {
          setState(() {
            userMaterials = value.data()["materials"];
          }),
          getMaterials()
        });
  }

  filterMaterials(materials) {
    List data = [];
    print(materials);
    for (int i = 0; i < materials.length; i++) {
      if (userMaterials != null) {
        if (userMaterials.contains(materials[i].id)) {
          data.add(materials[i]);
        }
      }
    }

    return data;
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

    myDownloadedListViews.add(
      TitleView(
        titleTxt: capitalize(widget.label) +
            " downloaded" +
            ' (' +
            itemCount.toString() +
            ')',
        showIcon: false,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
      ),
    );

    if (itemCount != 0) {
      for (int i = 0; i < itemCount; i++) {
        final Animation<double> animation =
            Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval((1 / data.length) * i, 1.0,
                curve: Curves.fastOutSlowIn),
          ),
        );
        myDownloadedListViews.add(
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
                          onTap: () async {
                            final externalDirectory =
                                await getExternalStorageDirectory();
                            // var filePath =
                            //     externalDirectory.path + "/" + data[i].uploadID;
                            var disabledElements = [
                              Buttons.shareButton,
                              Buttons.saveCopyButton,
                              Buttons.printButton,
                              Buttons.editPagesButton
                            ];

                            var config = Config();
                            config.disabledElements = disabledElements;
                            PdftronFlutter.openDocument(data[i].link,
                                config: config);
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
                                    color: HexColor("#FFB295").withOpacity(0.6),
                                    offset: const Offset(1.1, 4.0),
                                    blurRadius: 8.0),
                              ],
                              gradient: LinearGradient(
                                colors: <HexColor>[
                                  HexColor("#FA7D82"),
                                  HexColor("#FFB295"),
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
                                // Row(
                                //   children: <Widget>[
                                //     Text(
                                //       data[i].rating.toString(),
                                //       style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 20,
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        )),
                  ));
            },
          ),
        );
      }
    } else {
      myDownloadedListViews.add(Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No " +
              widget.label.toLowerCase() +
              " downloaded yet. Please Go to Download " +
              capitalize(widget.label) +
              " section to download.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontSize: 15),
        ),
      ));
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
            itemCount: myDownloadedListViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              animationController.forward();
              return Container(
                  padding: EdgeInsets.all(15.0),
                  child: myDownloadedListViews[index]);
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
                                  capitalize(widget.label),
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
                                    "My " + capitalize(widget.label),
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
