import 'package:flutter/material.dart';
import 'package:talita/resources.dart';

class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> tenCards = List.generate(10, (index) {
      return getBookmarkItem(index + 1);
    });
    return Scaffold(
        body: ListView(
      children: tenCards,
    ));
  }

  getBookmarkItem(int index) {
    return Container(
      child: Card(
          child: InkWell(
        splashColor: Color(ColorRes.lightCornYellow),
        onTap: () {
          print("Bookmark Clicked");
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/movie-placeholder.gif',
                height: 150,
                fit: BoxFit.cover,
              ),
              Text("$index Good Day",
                  style: TextStyle(color: Color(ColorRes.greenAccent)))
            ],
          ),
        ),
      )),
    );
  }
}
