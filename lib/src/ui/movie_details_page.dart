import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:talita/src/blocs/movies_bloc.dart';
import 'package:talita/src/models/cast_and_crew.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';

import 'package:talita/src/resources/api_provider.dart';
import 'package:talita/src/models/cast.dart';
import 'package:talita/src/models/movie.dart';
import 'package:talita/src/models/movie_detail.dart';
import 'package:talita/src/models/video.dart';
import 'package:talita/utils.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  MovieDetailsPage({Key key, this.movie}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

enum loadingState { loading, error, success }

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  ApiProvider api = ApiProvider();

  // List<Video> movieVideos;

  YoutubePlayerController _controller;
  var _playerState = PlayerState.unknown;
  var _videoMetaData;

  bool _isPlayerReady = false;
  bool _showPlayer = false;
  var videoId = "";
  Box<dynamic> _bookmarkBox;
  bool isBookmarked = false;
  var movieVideosLoadState = loadingState.loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey, appBar: detailsHeader(), body: detailsBody());
  }

  @override
  initState() {
    super.initState();
    int id = widget.movie.id;
    bloc.fetchMovieDetails(id);
    bloc.fetchMovieCastAndCrew(id);
    bloc.fetchMovieVideos(id);

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
          autoPlay: false, controlsVisibleAtStart: true, mute: false),
    );
    bloc.movieVideos.forEach((videos) {
      initMovieVideos(videos);
    });

    _bookmarkBox = Hive.box("bookmarks");
    isBookmarked = _bookmarkBox.containsKey("${widget.movie.id}");
  }

  initMovieVideos(List<Video> movieVideos) async {
    setState(() {
      movieVideosLoadState = loadingState.success;
      if (movieVideos.isNotEmpty) {
        videoId = movieVideos.firstWhere((video) {
          return video.site == "YouTube" && video.type == "Trailer";
        }, orElse: () {
          return movieVideos.firstWhere((video) {
            return video.site == "YouTube" && video.type == "Teaser";
          }, orElse: () => Video());
        }).key;
      }
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    });
  }

  detailsHeader() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 260),
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          image: DecorationImage(
            image: widget.movie.poster_path != null
                ? NetworkImage(ApiProvider().getImageUrl(
                    path: widget.movie.poster_path, size: PosterSizes.w500))
                : AssetImage("images/movie-placeholder.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child:
                              Icon(Icons.arrow_back_ios, color: Colors.white),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        GestureDetector(
                          child: isBookmarked
                              ? Icon(Icons.bookmark, color: Colors.white)
                              : Icon(Icons.bookmark_border,
                                  color: Colors.white),
                          onTap: () => _bookmarkMovie(),
                        )
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Tooltip(
                                message: widget.movie.title,
                                showDuration: Duration(seconds: 30),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    text: widget.movie.title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              ' (${Utils.getDateFromString(widget.movie.release_date).year})',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '${widget.movie.vote_count} votes',
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 24),
                                  Text(
                                    '${widget.movie.vote_average} rating',
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            child: Icon(
                              Icons.play_circle_filled,
                              color: Colors.greenAccent[400],
                              size: 50,
                            ),
                            onTap: () {
                              setState(() {
                                if (videoId.isNotEmpty) {
                                  _showPlayer = true;
                                  _controller.play();
                                } else {
                                  print("Videos not loaded!");
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
                child: Visibility(
                    visible: _showPlayer, child: createYoutubePlayer())),
          ],
        ),
      ),
    );
  }

  detailsBody() {
    var releaseDate = DateFormat.yMMMMd()
        .format(Utils.getDateFromString(widget.movie.release_date));
    return StreamBuilder(
      stream: bloc.movieDetails,
      builder: (context, AsyncSnapshot<Movie_detail> snapshot) {
        var movieDetail = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              snapshot.hasError
                  ? Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Error loading some details!",
                        style: TextStyle(color: Colors.red),
                      ))
                  : Container(),
              SizedBox(height: 20),
              Row(children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text.rich(
                          TextSpan(
                              text: "Release date:\n",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ColorRes.richBlack,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: releaseDate,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: ColorRes.pacificBlue,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text.rich(
                          TextSpan(
                              text: "Runtime: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ColorRes.richBlack,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${movieDetail?.runtime ?? ""} mins',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: ColorRes.pacificBlue,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text.rich(
                          TextSpan(
                              text: "Budget: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ColorRes.richBlack,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'USD ${movieDetail?.budget ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: ColorRes.pacificBlue,
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text.rich(
                          TextSpan(
                              text: "Revenue: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ColorRes.richBlack,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'USD ${movieDetail?.revenue ?? ""}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: ColorRes.pacificBlue,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        ),
                      ]),
                ),
                Expanded(
                  child: FlatButton(
                      child: Image.asset(
                        "images/imdb.png",
                        height: 60,
                      ),
                      onPressed: () => _launchUrl(
                          "https://www.imdb.com/title/${movieDetail.imdb_id}")),
                ),
              ]),
              SizedBox(height: 8),
              Text.rich(
                TextSpan(
                    text: "Official Website:\n",
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorRes.richBlack,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                          text: movieDetail?.homepage ?? "",
                          style: TextStyle(
                              fontSize: 16,
                              color: ColorRes.pacificBlue,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dashed),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchUrl(movieDetail?.homepage)),
                    ]),
              ),
              Divider(),
              Text("Storyline",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  widget.movie.overview,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("Cast",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorRes.richBlack)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: castAndCrewLayout(),
                    ),
                  ]),
            ],
          ),
        );
      },
    );
  }

  castAndCrewLayout() {
    return StreamBuilder(
        stream: bloc.movieCastAndCrew,
        builder: (context, AsyncSnapshot<Cast_and_crew> snapshot) {
          if (snapshot.hasData) {
            Cast_and_crew castAndCrew = snapshot.data;
            return SizedBox(
              height: 170,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: castAndCrew?.cast?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    Cast cast = castAndCrew?.cast[index];
                    return Container(
                      height: 100.0,
                      width: 85.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: cast?.profile_path != null
                                ? NetworkImage(
                                    api.getImageUrl(
                                        path: cast?.profile_path,
                                        size: PosterSizes.w154),
                                  )
                                : AssetImage("images/cast_placeholder.png"),
                          ),
                          Text(
                            cast?.name ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                          ),
                          Text(
                            cast?.character ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: ColorRes.pacificBlue),
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    );
                  }),
            );
          } else if (!snapshot.hasData) {
            return Text("No cast data...", style: TextStyle(fontSize: 16.0));
          } else if (snapshot.hasError) {
            return Text("Error loading cast...",
                style: TextStyle(fontSize: 16.0));
          }
          return Text("Loading Cast...", style: TextStyle(fontSize: 16.0));
        });
  }

  createYoutubePlayer() {
    return YoutubePlayer(
      aspectRatio: 1.0,
      progressIndicatorColor: ColorRes.greenAccent,
      thumbnailUrl: api.getImageUrl(path: widget.movie.poster_path),
      topActions: <Widget>[
        IconButton(
            color: Colors.white,
            onPressed: () {
              _controller.pause();
              setState(() => _showPlayer = false);
            },
            icon: Icon(Icons.close))
      ],
      onReady: () {
        _isPlayerReady = true;
        _controller.addListener(listener);
      },
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  _bookmarkMovie() {
    if (isBookmarked) {
      _bookmarkBox.delete("${widget.movie.id}");
      globalKey.currentState
          .showSnackBar(SnackBar(content: Text("Bookmark Removed")));
    } else {
      _bookmarkBox.put("${widget.movie.id}", json.encode(widget.movie));
      globalKey.currentState
          .showSnackBar(SnackBar(content: Text("Bookmarked")));
    }

    if (_bookmarkBox.isNotEmpty)
      _bookmarkBox.values.forEach((b) {
        print(b.toString());
      });
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Can\'t lanunch this url: $url');
    }
  }
}
