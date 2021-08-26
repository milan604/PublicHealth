import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:PublicHealth/src/ph/models/materials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../main.dart';
import '../ph_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:PublicHealth/src/ph/course/viewmodel.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:PublicHealth/src/globals.dart' as globals;

const debug = true;
final userRef = FirebaseFirestore.instance.collection("users");

class SearchData extends StatefulWidget {
  SearchData(
      {Key key, this.topicID, this.title, this.label, this.animationController})
      : super(key: key);
  final String topicID;
  final String title;
  final String label;
  final AnimationController animationController;

  @override
  _SearchDataState createState() => _SearchDataState();
}

class _SearchDataState extends State<SearchData> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  AnimationController animationController;
  List materials;
  List items = [];
  String errorMessage;
  TextEditingController editingController = TextEditingController();
  bool clicked = false;
  var storage = FirebaseStorage.instance;
  bool downloading = false;
  Map user = {};
  List userMaterials = [];

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    readUserFirestore(globals.userID);
    // initDownloader();
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

  readUserFirestore(userId) async {
    await userRef.doc(userId).get().then((value) => {
          setState(() {
            userMaterials = value.data()["materials"];
          }),
        });
  }

  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   if (debug) {
  //     print(
  //         'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
  //   }
  //   final SendPort send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send.send([id, status, progress]);
  // }

  void initDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: debug // optional: set false to disable printing logs to console
        );
  }

  void addItemsToTheList() {
    for (int count = 1; count <= 100; count++) {
      items.add("Book " + count.toString());
    }
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
          items = [];
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
      List searchedList = [];
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
      child: items.length == 0
          ? Padding(
              padding: EdgeInsets.only(left: 150, top: 150),
              child: Text(
                'No Data Found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: PHTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: 1.2,
                  color: Colors.red,
                ),
              ))
          : ListView.builder(
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
                              child: InkWell(
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  splashColor: PHTheme.nearlyDarkBlue,
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                      expand: true,
                                      context: context,
                                      backgroundColor: Colors.white,
                                      builder: (context) =>
                                          bottomModal(items[index]),
                                    );
                                  },
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
                                              color: HexColor(
                                                      items[index].endColor)
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${items[index].title}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'popins',
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          )),
                                        ],
                                      )))),
                        ));
                  },
                );
              },
            ),
    );
  }

  updateUserFirestore(userId, materialID) async {
    DocumentSnapshot doc = await userRef.doc(userId).get();
    if (!doc.exists) {
      print("User does not exist");
      return;
    }

    userRef.doc(userId).update({
      "materials": FieldValue.arrayUnion([materialID])
    });
    doc = await userRef.doc(userId).get();
  }

  Widget bottomModal(data) {
    readUserFirestore(globals.userID);
    bool _show = true;
    // bool _showButton = false;
    if (userMaterials != null) {
      if (userMaterials.contains(data.id)) {
        _show = false;
      }
    }
    return Container(
        decoration: BoxDecoration(color: PHTheme.nearlyBlack),
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Text(
                      "Book Title",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.title,
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
                      data.description,
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
                      "Author",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.author,
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
                    _show
                        ? ViewModelProvider<MyViewModel>.withConsumer(
                            viewModelBuilder: () => MyViewModel(),
                            builder: (context, model, child) =>
                                Column(children: <Widget>[
                                  Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor: Colors.white,
                                        onTap: () async {
                                          final status = await Permission
                                              .storage
                                              .request();
                                          if (status.isGranted) {
                                            final externalDirectory =
                                                await getExternalStorageDirectory();
                                            if (model.downloadProgress <= 0) {
                                              model.startDownloading(
                                                  data.link,
                                                  externalDirectory,
                                                  data.uploadID);
                                              // store information to User DB

                                              updateUserFirestore(
                                                  globals.userID, data.id);
                                            } else {
                                              print("Download in Progress");
                                            }
                                          } else {
                                            print("Permission Denied");
                                          }
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 13),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          child: model.downloadedProgress == 0
                                              ? Text(
                                                  'Download',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontFamily: "Poppins"),
                                                )
                                              : model.downloadedProgress == 2
                                                  ? Text(
                                                      'Downloaded',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "Poppins"),
                                                    )
                                                  : Text(
                                                      'Downloading...',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "Poppins"),
                                                    ),
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: SizedBox(
                                          height: 10,
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.transparent,
                                            color: Colors.orange,
                                            value: model.downloadProgress,
                                          )))
                                ]))
                        : Text(
                            "Content Already Downloaded",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white,
                                fontFamily: PHTheme.fontName,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                    Text(
                      "The Downloaded content will be added to your My" +
                          capitalize(widget.label) +
                          " section",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: HexColor("#a2d923"),
                          fontFamily: PHTheme.fontName,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
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
