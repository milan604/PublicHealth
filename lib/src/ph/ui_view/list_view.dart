import 'package:flutter/material.dart';

class ListContentView extends StatefulWidget {
  ListContentView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _ListContentViewState createState() => _ListContentViewState();
}

class _ListContentViewState extends State<ListContentView>
    with TickerProviderStateMixin {
  List<String> listData = <String>[
    'assets/books.png',
    'assets/slides.png',
    'assets/articles.jpg',
    'assets/videos.png',
  ];
  AnimationController animationController;

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
                  child: Text("Milan"),
                ),
              ),
            ));
      },
    );
  }
}
