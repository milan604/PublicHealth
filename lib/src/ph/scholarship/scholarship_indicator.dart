import 'package:flutter/material.dart';
import 'package:PublicHealth/main.dart';

class ScholarshipIndicator extends StatelessWidget {
  const ScholarshipIndicator({Key key, this.date, this.flag}) : super(key: key);

  final String date;
  final bool flag;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: HexColor("#F2F3F8"),
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: flag
                  ? Border(
                      bottom: BorderSide(width: 3, color: Colors.orange),
                      right: BorderSide(width: 4, color: Colors.orange),
                      left: BorderSide(width: 1, color: Colors.orange),
                      top: BorderSide(width: 1, color: Colors.orange))
                  : Border(
                      bottom: BorderSide(width: 3, color: Colors.orange),
                      left: BorderSide(width: 4, color: Colors.orange),
                      top: BorderSide(width: 1, color: Colors.orange),
                      right: BorderSide(width: 1, color: Colors.orange)),
            ),
            child: Text(
              date,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.purple,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
