import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'home_page.dart';
import 'home_page2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox("app_data");
  await Hive.openBox("bookmarks");
  
  runApp(MovieApp());
}

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
      fontFamily: "ProductSans");
}
