import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:talita/src/resources/api_provider.dart';
import 'package:talita/src/models/movie.dart';
import 'package:talita/utils.dart';
import 'movie_details_page.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  Box<dynamic> _bookmarkBox;
  @override
  void initState() {
    _bookmarkBox = Hive.box("bookmarks");

    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   List<Widget> tenCards = List.generate(10, (index) {
  //     return _buildBookmarkItem(context, index + 1);
  //   });
  //   return Scaffold(
  //       body: FutureBuilder(
  //           future: Hive.openBox("bookmarks"),
  //           builder: (context, snapshot) {
  //             if (snapshot.hasError) return Text("An error occurred!");
  //             if (!snapshot.hasData) return Text("No Bookmarks found");
  //             return ListView(
  //               children: <Widget>[
  //                 for (dynamic data in _bookmarkBox)_buildBookmarkItem(context, snapshot.data)
  //               ],
  //             );
  //           }));
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bookmarkBox.isNotEmpty
          ? ListView.builder(
              itemCount: _bookmarkBox.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildBookmarkItem(context, _bookmarkBox.getAt(index));
              })
          : Center(child: Text("No Bookmarks found")),
    );
  }

  _buildBookmarkItem(BuildContext context, bookmark) {
    Movie movie = Movie.fromJson(json.decode(bookmark.toString()));
    
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(movie: movie),
        ),
      ),
      child: Container(
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: Image.network(
                      ApiProvider().getImageUrl(
                          path: movie.poster_path, size: PosterSizes.w500),
                      fit: BoxFit.cover,
                      height: 120,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text("${movie.title}",
                          style: TextStyle(
                              fontSize: 16,
                              color: ColorRes.richBlack,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${movie.overview}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "${movie.vote_average}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
