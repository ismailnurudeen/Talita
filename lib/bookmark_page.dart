import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:talita/resources.dart';

import 'api.dart';
import 'image_config.dart';
import 'movie_details_page.dart';

class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> tenCards = List.generate(10, (index) {
      return BuildBookmarkItem(context, index + 1);
    });
    return Scaffold(
        body: ListView(
      children: tenCards,
    ));
  }

  BuildBookmarkItem(BuildContext context, int index) {
    return GestureDetector(
      // onTap: () => Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => MovieDetailsPage(movie: filteredList[index]),
      //   ),
      // ),
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
                    child: Image.asset(
                      "images/movie-placeholder.gif",
                      fit: BoxFit.cover,
                      height: 120,
                    ),
                    //  Image.network(
                    //   Api().getImageUrl(
                    //       path:
                    //           filteredList[index].poster_path,
                    //       size: PosterSizes.w500),
                    //   fit: BoxFit.cover,
                    //   height: 120,
                    // ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text("Movie $index",
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
                        "Overview",
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
                            "6.5",
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

  var _box = Hive.box("app_data");
  List<int> _getbookmarks() {
    List<int> bookmarkIds = _box.get("bookmarks");
    return bookmarkIds;
  }
}
