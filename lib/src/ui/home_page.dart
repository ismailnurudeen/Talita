import 'package:flutter/material.dart';
import 'package:talita/src/blocs/movies_bloc.dart';
import 'package:talita/src/resources/api_provider.dart';
import 'package:talita/src/ui/bookmark_page.dart';
import 'package:talita/src/ui/movie_details_page.dart';
import 'package:talita/src/ui/search_page.dart';
import 'package:talita/utils.dart';
import 'package:talita/src/models/movie.dart';
import 'package:talita/src/models/movie_response.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum MovieCategory { popular, top, latest }

class _HomePageState extends State<HomePage> {
  String appBarTitle = "Talita - Best Animated Movies";
  int _currentTabIndex = 0;

  List<Movie> movies = [];

  ApiProvider api = ApiProvider();
  @override
  void initState() {
    super.initState();

    bloc.allMovies.forEach((movieResponse) {
      movies = movieResponse.results;
    });

    bloc.fetchPopularMovies();
    bloc.fetchTopRatedMovies();
    bloc.fetchLatestMovies();
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
        _buildMovieSection(context, MovieCategory.popular),
        // Top rated
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
        _buildMovieSection(context, MovieCategory.top),
        // Upcoming
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
        _buildMovieSection(context, MovieCategory.latest),
        SizedBox(height: 16.0)
      ],
    );
  }

  _buildMovieSection(BuildContext context, MovieCategory category) {
    Stream<Movie_response> movieStream;
    if (category == MovieCategory.popular) {
      movieStream = bloc.popularMovies;
    } else if (category == MovieCategory.top) {
      movieStream = bloc.topRatedMovies;
    } else if (category == MovieCategory.latest) {
      movieStream = bloc.latestMovies;
    } else {
      movieStream = bloc.allMovies;
    }

    return StreamBuilder(
        stream: movieStream,
        builder: (context, AsyncSnapshot<Movie_response> snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 325,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return movieItemCard(snapshot.data.results, index);
                },
                itemCount: snapshot.data.results.length,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: " + snapshot.error.toString()));
          }

          return Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 100),
            child: CircularProgressIndicator(),
          );
        });
  }

  movieItemCard(List<Movie> movies, int index) {
    Movie currentMovie = movies[index];

    var releaseDate = Utils.getDateFromString(currentMovie.release_date);
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
            Text(
              "(${releaseDate.year})",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Icon(Icons.star, color: Colors.yellow),
                Text('${currentMovie.vote_average}')
              ],
            ),
          ],
        ),
      ),
    );
  }

  getMovieImageWidget(String posterPath) {
    if (posterPath != null) {
      return Image.network(
        api.getImageUrl(path: posterPath, size: PosterSizes.w500),
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
