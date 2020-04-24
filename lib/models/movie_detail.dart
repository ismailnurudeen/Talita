import 'package:json_annotation/json_annotation.dart';
import 'package:talita/models/index.dart';
import "genre.dart";
part 'movie_detail.g.dart';

@JsonSerializable()
class Movie_detail {
  Movie_detail();

  bool adult;
  String backdrop_path;
  Map<String, dynamic> belongs_to_collection;
  num budget;
  List<Genre> genres;
  String homepage;
  num id;
  String imdb_id;
  String original_language;
  String original_title;
  String overview;
  num popularity;
  String poster_path;
  List production_companies;
  List production_countries;
  String release_date;
  num revenue;
  num runtime;
  List spoken_languages;
  String status;
  String tagline;
  String title;
  bool video;
  num vote_average;
  num vote_count;

  factory Movie_detail.fromJson(Map<String, dynamic> json) =>
      _$Movie_detailFromJson(json);
  Map<String, dynamic> toJson() => _$Movie_detailToJson(this);
}
