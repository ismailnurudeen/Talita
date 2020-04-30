import 'package:talita/src/models/cast_and_crew.dart';
import 'package:talita/src/models/movie_detail.dart';
import 'package:talita/src/models/movie_response.dart';
import 'package:talita/src/models/video.dart';
import 'package:talita/src/resources/api_provider.dart';

class Repository {
  ApiProvider apiProvider = ApiProvider();
  Future<Movie_response> fetchAllMovies() => apiProvider.fetchAllMovies();
  Future<Movie_response> fetchPopularMovies() =>
      apiProvider.fetchPopularMovies();
  Future<Movie_response> fetchTopRatedMovies() =>
      apiProvider.fetchTopRatedMovies();
  Future<Movie_response> fetchLatestMovies() => apiProvider.fetchLatestMovies();
  Future<Movie_detail> fetchMovieDetails(int id) =>
      apiProvider.fetchMovieDetails(id);
  Future<Cast_and_crew> fetchMovieCastAndCrew(int id) =>
      apiProvider.fetchMovieCastAndCrew(id);
  Future<List<Video>> fetchMovieVideos(int id) =>
      apiProvider.fetchMovieVideos(id);
}
