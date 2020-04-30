import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:talita/src/resources/api_provider.dart';

import 'package:talita/src/models/movie.dart';
import 'package:talita/utils.dart';
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
  bool _contentNotFound = false;
  TextEditingController _tec = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _searchField(),
          Expanded(
              child: filteredList.isEmpty
                  ? (_contentNotFound
                      ? Center(child: noSearchContent)
                      : _searchHistoryWidget())
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildSearchResultItem(context, index);
                      })),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
      margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: TextField(
        controller: _tec,
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
          _performFilter(query.trim());
        },
        onChanged: (query) {
          setState(() {
            if (query.isEmpty) {
              filteredList.clear();
              _contentNotFound = false;
            }
          });
        },
      ),
    );
  }

  Widget _buildSearchResultItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(movie: filteredList[index]),
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
                          path: filteredList[index].poster_path,
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
                            '${filteredList[index].vote_average}',
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

  _searchHistoryWidget() {
    var searchHistory = _getSearchHistory();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: <Widget>[
              Icon(Icons.history),
              SizedBox(width: 4.0),
              Text("Previous Searches"),
              SizedBox(width: 4.0),
              IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () => _clearSearchHistory(),
              ),
            ]),
          ),
        ),
        SizedBox(height: 8.0, child: Divider()),
        Expanded(
          flex: 9,
          child: ListView.builder(
              itemCount: searchHistory?.length ?? 0,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _tec.text = searchHistory[index];
                    _performFilter(searchHistory[index]);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(searchHistory[index]),
                        ),
                        index != 9 ? Divider() : Container(),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  var _box = Hive.box("app_data");
  List _getSearchHistory() {
    return _box.get("search_history");
  }

  _addSearchHistory(String query) {
    List searchHistory = _getSearchHistory() ?? [];
    if (searchHistory.length < 10) {
      if (searchHistory.contains(query)) {
        searchHistory.removeAt(searchHistory.indexOf(query));
      }
      searchHistory.add(query);
    } else {
      searchHistory.removeAt(0);
      searchHistory.add(query);
    }
    _box.put("search_history", searchHistory);
  }

  _clearSearchHistory() {
    setState(() {
      _box.put("search_history", []);
    });
  }

  _performFilter(String query) {
    _addSearchHistory(query);
    List<Movie> tempMovieList = [];
    filteredList.clear();
    if (query.isEmpty) {
      setState(() {
        noSearchContent = Text("No movie found!");
      });
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
        _contentNotFound = true;
      }
      filteredList.addAll(tempMovieList);
    });
  }
}
