import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talita/api.dart';
import 'package:talita/image_config.dart';
import 'package:talita/models/index.dart';
import 'package:talita/movie_details_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'models/movie.dart';
import 'models/movie_response.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  Api api = Api();
  @override
  void initState() {
    super.initState();
    this.getMoviesJson();
  }

  String appBarTitle = "Talita - Best Animated Movies";
  int _currentIndex = 0;
  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Movies")),
    BottomNavigationBarItem(
        icon: Icon(Icons.bookmark_border),
        activeIcon: Icon(Icons.bookmark),
        title: Text("Bookmarks")),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(context, appBarTitle),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: bottomNavItems,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
              appBarTitle =
                  index == 0 ? "Talita - Best Animated Movies" : "Bookmarks";
            });
          },
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              StaggeredGridView.countBuilder(
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                crossAxisCount: 2,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return movieItemCard1(index);
                },
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.count(2, index.isEven ? 2 : 1),
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return movieItemCard2(index);
                },
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return movieItemCard3(index);
                },
                itemCount: movies.length,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getMoviesJson() async {
    http.Response response = await http.get(
        Uri.encodeFull(api.getCartoonsEndpoint()),
        headers: {"Accept": "application/json"});
    print(response.body);

    Map<String, dynamic> moviesResponseMap = jsonDecode(response.body);
    var movieResponse = Movie_response.fromJson(moviesResponseMap);

    setState(() {
      movies = movieResponse.results;
    });

    return "Success";
  }

  movieItemCard1(int index) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MovieDetailsPage(movie: movies[index]))),
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Image.network(
                    api.getImageUrl(
                        path: movies[index].poster_path,
                        size: PosterSizes.w500),
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
              ),
            ),
            Text(
              movies[index].title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: "ProductSans"),
            ),
            //Text(genreTags(movies[index].genre_ids))
          ],
        ),
    );
  }

  movieItemCard2(int index) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MovieDetailsPage(movie: movies[index]))),
      child: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Container(
              width: 250,
              height: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Image.network(
                  api.getImageUrl(
                      path: movies[index].poster_path, size: PosterSizes.w500),
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
            ),
          ),
          Text(
            movies[index].title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: "ProductSans"),
          ),
          //Text(genreTags(movies[index].genre_ids))
        ],
      ),
    );
  }

  movieItemCard3(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MovieDetailsPage(movie: movies[index]))),
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Container(
                width: 250,
                height: 350,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Image.network(
                    api.getImageUrl(
                        path: movies[index].poster_path,
                        size: PosterSizes.w500),
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              ),
            ),
            Text(
              movies[index].title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: "ProductSans"),
            ),
            //Text(genreTags(movies[index].genre_ids))
          ],
        ),
      ),
    );
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
      height: 150,
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
          child: Container(
            margin: EdgeInsets.fromLTRB(8, 16, 0, 0),
            child: Column(
              children: <Widget>[
                Text(title,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "Ubuntu")),
                SizedBox(
                  height: 20,
                ),
                customTabBar
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

TabBar customTabBar = TabBar(
  indicatorSize: TabBarIndicatorSize.label,
  labelColor: Colors.black,
  unselectedLabelColor: Colors.black,
  indicator: BoxDecoration(
    color: Colors.greenAccent[400],
    borderRadius: BorderRadius.all(
      Radius.circular(50),
    ),
  ),
  tabs: <Tab>[
    Tab(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Align(
          child: Text("Popular"),
        ),
      ),
    ),
    Tab(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Align(
          child: Text("Latest"),
        ),
      ),
    ),
    Tab(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Align(
          child: Text("Top Rated"),
        ),
      ),
    ),
  ],
);
