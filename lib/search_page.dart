import 'package:flutter/material.dart';
import 'package:talita/api.dart';
import 'package:talita/resources.dart';

import 'image_config.dart';
import 'models/movie.dart';
import 'movie_details_page.dart';

class SearchPage extends StatefulWidget {
  final List<Movie> movies;
  SearchPage({Key key, this.movies}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Movie> filteredList = [];
  Widget noSearchContent = Text("Search for your Favorite Animated Movies.");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search for movies",
                hasFloatingPlaceholder: false,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              ),
              onSubmitted: (query) {
                  _performFilter(query);
              },
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? Center(child: noSearchContent)
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsPage(movie: filteredList[index]),
                          ),
                        ),
                        child: Container(
                          height: 120,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                        Api().getImageUrl(
                                            path:
                                                filteredList[index].poster_path,
                                            size: PosterSizes.w500),
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
                                        Text(filteredList[index].title,
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
                                          filteredList[index].overview,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Text(
                                              '${filteredList[index].vote_average}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
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
                    }),
          ),
        ],
      ),
    );
  }

  _performFilter(String query) {
    List<Movie> tempMovieList = [];
    filteredList.clear();
    if (query.isEmpty) {
      noSearchContent = Text("No movie found!");
      return;
    }
    widget.movies.forEach((movie) {
      String titleLowerCase = movie.title.toLowerCase();
      String originalTitleLowerCase = movie.original_title.toLowerCase();
      String queryLowerCase = query.toLowerCase();

      if (titleLowerCase.contains(queryLowerCase) ||
          originalTitleLowerCase.contains(queryLowerCase)) {
        tempMovieList.add(movie);
        print(query + " ${movie.title}");
      }
    });
    setState(() {
      if (tempMovieList.isEmpty) {
        noSearchContent = Text("No movie found!");
      }
      filteredList.addAll(tempMovieList);
    });
  }
}
