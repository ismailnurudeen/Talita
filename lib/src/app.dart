import 'package:flutter/material.dart';
import 'package:talita/src/ui/home_page.dart';

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: _buildTheme(),
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}

_buildTheme() {
  return ThemeData(
      accentColor: Colors.greenAccent[200],
      primaryColor: Colors.yellow[700],
      primaryColorDark: Color(0x042A2B),
      fontFamily: "ProductSans");
}