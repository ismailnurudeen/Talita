import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talita/src/models/cast_and_crew.dart';
import 'package:talita/src/models/movie_detail.dart';
import 'package:talita/src/models/movie_response.dart';
import 'package:talita/src/models/video.dart';
import 'package:talita/src/models/video_response.dart';
import 'package:talita/utils.dart';

class ApiProvider {
  static String _api_key = '1b088d94b2b672e43fb86e45f714d3ea';
  String _token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYjA4OGQ5NGIyYjY3MmU0M2ZiODZlNDVmNzE0ZDNlYSIsInN1YiI6IjVlOWQ3NDVkNGE0YmZjMDAyM2Q3YmRjMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.5qp_0lbmQ6EzNE14LAkFrmFuMEDpdgUuthlLBoeSnQw';
  String _api_base = 'https://api.themoviedb.org/3/';
  String _api_cartoons = 'discover/movie?api_key=$_api_key&with_genres=16';
  String _guest_session = 'authentication/guest_session/new?api_key=$_api_key';

  String _getCartoonsEndpoint() => _api_base + _api_cartoons;
  String _getPopularCartoonsEndpoint({int pageIndex = 1}) {
    String popular_cartoons =
        'discover/movie?api_key=$_api_key&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=true&page=$pageIndex&with_genres=16';
    return _api_base + popular_cartoons;
  }

  String _getLatestCartoonsEndpoint({int pageIndex = 1}) {
    String latest_cartoons =
        'discover/movie?api_key=$_api_key&language=en-US&sort_by=release_date.desc&include_adult=false&include_video=true&page=$pageIndex&with_genres=16';
    return _api_base + latest_cartoons;
  }

  String _getTopRatedCartoonsEndpoint({int pageIndex = 1}) {
    String top_rated_cartoons =
        'discover/movie?api_key=$_api_key&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=true&page=$pageIndex&with_genres=16';
    return _api_base + top_rated_cartoons;
  }

  String getMovieDetailsEndpoint(String movieId) =>
      _api_base + 'movie/$movieId?api_key=$_api_key&language=en-US';

  String getMovieVideos(String movieId) =>
      _api_base + 'movie/$movieId/videos?api_key=$_api_key&language=en-US';

  String getImageUrl({String path, String size = PosterSizes.original}) =>
      ImageConfig.base_url + size + path;

  String getCastAndCrewEndPoint(String movieId) =>
      _api_base + "movie/$movieId/credits?api_key=$_api_key";

// API Calls
  Future<Movie_response> fetchAllMovies() async {
    http.Response response = await http.get(
        Uri.encodeFull(_getCartoonsEndpoint()),
        headers: {"Accept": "application/json"});
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> moviesResponseMap = jsonDecode(response.body);
      var movieResponse = Movie_response.fromJson(moviesResponseMap);
      return movieResponse;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Movie_response> fetchPopularMovies() async {
    http.Response response = await http.get(
        Uri.encodeFull(_getPopularCartoonsEndpoint()),
        headers: {"Accept": "application/json"});
    print("POPULAR\n\n" + response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> moviesResponseMap = jsonDecode(response.body);
      var movieResponse = Movie_response.fromJson(moviesResponseMap);
      return movieResponse;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<Movie_response> fetchLatestMovies() async {
    http.Response response = await http.get(
        Uri.encodeFull(_getLatestCartoonsEndpoint()),
        headers: {"Accept": "application/json"});
    print("LATEST\n\n" + response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> moviesResponseMap = jsonDecode(response.body);
      var movieResponse = Movie_response.fromJson(moviesResponseMap);
      return movieResponse;
    } else {
      throw Exception('Failed to load latest movies');
    }
  }

  Future<Movie_response> fetchTopRatedMovies() async {
    http.Response response = await http.get(
        Uri.encodeFull(_getTopRatedCartoonsEndpoint()),
        headers: {"Accept": "application/json"});
    print("TOP RATED\n\n" + response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> moviesResponseMap = jsonDecode(response.body);
      var movieResponse = Movie_response.fromJson(moviesResponseMap);
      return movieResponse;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<Cast_and_crew> fetchMovieCastAndCrew(int id) async {
    http.Response response = await http.get(getCastAndCrewEndPoint('$id}'),
        headers: {"Accept": "application/json"});

    // print('CAST AND CREW ${response.body}');
    return Cast_and_crew.fromJson(jsonDecode(response.body));
  }

  Future<Movie_detail> fetchMovieDetails(int id) async {
    http.Response response = await http.get(
        Uri.encodeFull(getMovieDetailsEndpoint('$id')),
        headers: {"Accept": "application/json"});

    print("MOVIE DETAILS:\n${response.body}");

    if (response.statusCode == 200) {
      return Movie_detail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load movie datails");
    }
  }

  Future<List<Video>> fetchMovieVideos(int id) async {
    http.Response response = await http.get(
        Uri.encodeFull(getMovieVideos('$id')),
        headers: {"Accept": "application/json"});
    // print("VIDEOS:\n\n${response.body}");

    if (response.statusCode == 200) {
      return Video_response.fromJson(jsonDecode(response.body)).results;
    } else {
      throw Exception("Failed to load videos");
    }
  }
}
