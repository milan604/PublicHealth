import 'package:flutter/material.dart';

class OfflineView extends StatelessWidget {
  const OfflineView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Please Check Your Internet Connection",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 40,
        ),
        CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        )
      ])),
    );
  }
}
