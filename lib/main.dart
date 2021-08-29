import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import './src/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:PublicHealth/src/services/authentication.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayColor: Colors.transparent,
        overlayOpacity: 0.4,
        overlayWidget: Center(
            child: Stack(children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.black),
              height: 300,
              width: 250,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 27),
                        child: Text(
                          'No Internet Connection',
                          style: GoogleFonts.portLligatSans(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ))
                  ])),
          Positioned(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      color: Colors.black),
                  child: Image.asset(
                    "assets/images/loader.gif",
                    width: 250,
                    height: 250,
                  )))
        ])),
        child: MaterialApp(
          title: 'Public Health',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
              bodyText2: GoogleFonts.montserrat(textStyle: textTheme.bodyText2),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: LoginPage(auth: new Auth()),
        ));
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
