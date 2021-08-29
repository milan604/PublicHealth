import 'package:flutter/material.dart';
import '../ph_theme.dart';

class LogoutView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const LogoutView(
      {Key key, this.animationController, this.animation, this.logout})
      : super(key: key);

  final VoidCallback logout;
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
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
                                  color: PHTheme.grey.withOpacity(0.4),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[],
                                  ),
                                  Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 16,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      child: _logoutButton(context),
                                    ),
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _logoutButton(context) {
    return Material(
        child: InkWell(
      splashColor: Colors.blue,
      onTap: () {
        logout();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.orange, width: 4),
          // color: Colors.green,
        ),
        child: Text(
          'Logout',
          style: TextStyle(fontSize: 25, color: Colors.orange),
        ),
      ),
    ));
  }
}
