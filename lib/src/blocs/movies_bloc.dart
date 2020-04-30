import 'package:rxdart/rxdart.dart';
import 'package:talita/src/models/cast_and_crew.dart';
import 'package:talita/src/models/movie_detail.dart';
import 'package:talita/src/models/movie_response.dart';
import 'package:talita/src/models/video.dart';
import 'package:talita/src/resources/repository.dart';

class MoviesBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<Movie_response>();
  final _popularMoviesFetcher = PublishSubject<Movie_response>();
  final _topRatedMoviesFetcher = PublishSubject<Movie_response>();
  final _latestMoviesFetcher = PublishSubject<Movie_response>();
  final _movieDetailsFetcher = PublishSubject<Movie_detail>();
  final _movieVideosFetcher = PublishSubject<List<Video>>();
  final _movieCastAndCrewFetcher = PublishSubject<Cast_and_crew>();

  Stream<Movie_response> get allMovies => _moviesFetcher.stream;
  Stream<Movie_response> get popularMovies => _popularMoviesFetcher.stream;
  Stream<Movie_response> get topRatedMovies => _topRatedMoviesFetcher.stream;
  Stream<Movie_response> get latestMovies => _latestMoviesFetcher.stream;

  Stream<Movie_detail> get movieDetails => _movieDetailsFetcher.stream;
  Stream<Cast_and_crew> get movieCastAndCrew => _movieCastAndCrewFetcher.stream;
  Stream<List<Video>> get movieVideos => _movieVideosFetcher.stream;

  fetchAllMovies() async {
    Movie_response movieResponse = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(movieResponse);
  }

  fetchPopularMovies() async {
    Movie_response movieResponse = await _repository.fetchPopularMovies();
    _popularMoviesFetcher.sink.add(movieResponse);
  }

  fetchTopRatedMovies() async {
    Movie_response movieResponse = await _repository.fetchTopRatedMovies();
    _topRatedMoviesFetcher.sink.add(movieResponse);
  }

  fetchLatestMovies() async {
    Movie_response movieResponse = await _repository.fetchLatestMovies();
    _latestMoviesFetcher.sink.add(movieResponse);
  }

  fetchMovieDetails(int id) async {
    Movie_detail movieDetail = await _repository.fetchMovieDetails(id);
    _movieDetailsFetcher.sink.add(movieDetail);
  }

  fetchMovieCastAndCrew(int id) async {
    Cast_and_crew castAndCrew = await _repository.fetchMovieCastAndCrew(id);
    _movieCastAndCrewFetcher.sink.add(castAndCrew);
  }

  fetchMovieVideos(int id) async {
    List<Video> videos = await _repository.fetchMovieVideos(id);
    _movieVideosFetcher.sink.add(videos);
  }

  dispose() {
    _moviesFetcher.close();
    _popularMoviesFetcher.close();
    _topRatedMoviesFetcher.close();
    _latestMoviesFetcher.close();
    _movieDetailsFetcher.close();
    _movieCastAndCrewFetcher.close();
    _movieVideosFetcher.close();
  }
}

final bloc = MoviesBloc();
