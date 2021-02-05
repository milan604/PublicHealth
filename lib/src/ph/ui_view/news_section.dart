import 'package:PublicHealth/src/ph/ph_theme.dart';
import 'package:flutter/material.dart';

class NewsSection extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const NewsSection({Key key, this.animationController, this.animation})
      : super(key: key);

  Widget newsSectionBox() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 230,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("July 10"),
                    Text(
                      'Covid-19 Death reach 100',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "In kushadevi of nepal covid 19 death toll has reached 100",
                      style: TextStyle(
                        fontFamily: 'Poppins-SemiBold',
                        fontSize: 15,
                        color: const Color(0xff000000),
                      ),
                    )
                  ],
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/gk.jpg',
                    height: 100,
                    width: 100,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person_outline,
                      color: Colors.green,
                    ),
                    Text("Milan Adhikari"),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        Icons.share,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        print("Hello Man");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: PHTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: PHTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    newsSectionBox(),
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
