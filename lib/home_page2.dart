import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talita/api.dart';
import 'package:talita/bookmark_page.dart';
import 'package:talita/image_config.dart';
import 'package:talita/models/index.dart';
import 'package:talita/movie_details_page.dart';
import 'package:talita/resources.dart';
import 'package:talita/search_page.dart';
import 'models/movie.dart';
import 'models/movie_response.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

enum MovieCategory { popular, top, latest }

class _HomePage2State extends State<HomePage2> {
  String appBarTitle = "Talita - Best Animated Movies";
  int _currentTabIndex = 0;
  List<Movie> movies = [];
  List<Movie> popularMovies = [];
  List<Movie> topMovies = [];
  List<Movie> recentMovies = [];

  Api api = Api();
  @override
  void initState() {
    super.initState();
    this.getMoviesJson();
    this.getPopularMoviesJson();
    this.getTopRatedMoviesJson();
    this.getLatestMoviesJson();
  }

  @override
  Widget build(BuildContext context) {
    final tabPages = <Widget>[
      _moviesTabPage(),
      SearchPage(movies: movies),
      BookmarkPage()
    ];

    List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(
          icon: Icon(Icons.local_movies), title: Text("Movies")),
      BottomNavigationBarItem(
          icon: Icon(Icons.search),
          activeIcon: Icon(Icons.find_in_page),
          title: Text("Search")),
      BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          activeIcon: Icon(Icons.bookmark),
          title: Text("Bookmarks")),
    ];
    assert(bottomNavItems.length == tabPages.length);
    return Scaffold(
        appBar: _buildAppBar(context, appBarTitle),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: bottomNavItems,
          currentIndex: _currentTabIndex,
          onTap: (int index) {
            setState(() {
              _currentTabIndex = index;
              appBarTitle = index == 0
                  ? "Talita - Best Animated Movies"
                  : index == 1 ? "Search" : "Bookmarks";
            });
          },
        ),
        body: tabPages[_currentTabIndex]);
  }

  _moviesTabPage() {
    return ListView(
      children: <Widget>[
// Popular
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0, 0),
          child: Text(
            "POPULAR",
            style: TextStyle(
                fontSize: 18,
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.bold,
                color: ColorRes.greenAccent),
          ),
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return movieItemCard(MovieCategory.popular, index);
            },
            itemCount: popularMovies.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
          child: Text(
            "TOP RATED",
            style: TextStyle(
                fontSize: 18,
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.bold,
                color: ColorRes.greenAccent),
          ),
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return movieItemCard(MovieCategory.top, index);
            },
            itemCount: topMovies.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
          child: Text(
            "UPCOMING",
            style: TextStyle(
                fontSize: 18,
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.bold,
                color: ColorRes.greenAccent),
          ),
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return movieItemCard(MovieCategory.latest, index);
            },
            itemCount: recentMovies.length,
          ),
        ),
        SizedBox(height: 16.0)
      ],
    );
  }

  _searchTabPage() {
    return Container(
      child: Center(
        child: Icon(Icons.filter),
      ),
    );
  }

  _bookmarkTabPage() {
    Container(
      child: Center(
        child: Icon(Icons.movie_filter),
      ),
    );
  }

  Future<String> getMoviesJson() async {
    http.Response response = await http.get(
        Uri.encodeFull(api.getCartoonsEndpoint()),
        headers: {"Accept": "application/json"});
    // print(response.body);

    Map<String, dynamic> moviesResponseMap = jsonDecode(response.body);
    var movieResponse = Movie_response.fromJson(moviesResponseMap);

    setState(() {
      movies = movieResponse.results;
    });

    return "Success";
  }

  Future<String> getPopularMoviesJson() async {
    http.Response response = await http.get(
        Uri.encodeFull(api.getPopularCartoonsEndpoint()),
        headers: {"Accept": "application/json"});
    print("POPULAR\n\n" + response.body);

    Map<String, dynamic> moviesResponseMap = jsonDecode(response.body);
    var movieResponse = Movie_response.fromJson(moviesResponseMap);

    setState(() {
      popularMovies = movieResponse.results;
    });

    return "Success";
  }

  Future<String> getLatestMoviesJson() async {
    http.Response response = await http.get(
        Uri.encodeFull(api.getLatestCartoonsEndpoint()),
        headers: {"Accept": "application/json"});
    print("LATEST\n\n" + response.body);

    Map<String, dynamic> moviesResponseMap = jsonDecode(response.body);
    var movieResponse = Movie_response.fromJson(moviesResponseMap);

    setState(() {
      recentMovies = movieResponse.results;
    });

    return "Success";
  }

  Future<String> getTopRatedMoviesJson() async {
    http.Response response = await http.get(
        Uri.encodeFull(api.getTopRatedCartoonsEndpoint()),
        headers: {"Accept": "application/json"});
    print("TOP RATED\n\n" + response.body);

    Map<String, dynamic> moviesResponseMap = jsonDecode(response.body);
    var movieResponse = Movie_response.fromJson(moviesResponseMap);

    setState(() {
      topMovies = movieResponse.results;
    });

    return "Success";
  }

  movieItemCard(MovieCategory category, int index) {
    Movie currentMovie;
    if (category == MovieCategory.popular) {
      currentMovie = popularMovies[index];
    } else if (category == MovieCategory.latest) {
      currentMovie = recentMovies[index];
    } else if (category == MovieCategory.top) {
      currentMovie = topMovies[index];
    } else {
      currentMovie = movies[index];
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MovieDetailsPage(movie: currentMovie))),
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Container(
                width: 150,
                height: 200,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: getMovieImageWidget(currentMovie.poster_path)),
              ),
            ),
            Flexible(
              child: Container(
                width: 150,
                child: Text(
                  currentMovie.title,
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "ProductSans"),
                ),
              ),
            ),
            //Text(genreTags(currentMovie[index].genre_ids))
          ],
        ),
      ),
    );
  }

  getMovieImageWidget(String posterPath) {
    if (posterPath != null) {
      return Image.network(
        api.getImageUrl(path: posterPath, size: PosterSizes.original),
        fit: BoxFit.cover,
        height: 200,
      );
    } else {
      return Image.asset(
        "images/movie-placeholder.gif",
        scale: 1.5,
        fit: BoxFit.cover,
      );
    }
  }

  genreTags(List gerneIds) {
    String genreTags;
    gerneIds.forEach((id) {
      genreTags += id + ",";
    });
    return genreTags.substring(0, genreTags.length - 1);
  }
}

_buildAppBar(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: Size(double.infinity, 200),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5,
            blurRadius: 2,
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[600],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
            child: Center(
          child: Container(
            child: Align(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, color: Colors.white, fontFamily: "Ubuntu"),
              ),
            ),
          ),
        )),
      ),
    ),
  );
}
