import 'package:flutter/material.dart';

import 'home_page.dart';
import 'home_page2.dart';

void main() => runApp(MovieApp());

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: _buildTheme(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/a": (BuildContext context) => HomePage()
        },
        home: HomePage2());
  }
}

_buildTheme() {
  return ThemeData(
    accentColor: Colors.greenAccent[200],
    primaryColor: Colors.yellow[700],
    primaryColorDark: Color(0x042A2B),
    fontFamily: "ProductSans"
  );
}
