import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

// @HiveType(typeId: 0)
@JsonSerializable()
class Movie extends HiveObject {
  Movie();
  // @HiveField(0)
  num popularity;
  // @HiveField(1)
  num vote_count;
  // @HiveField(2)
  bool video;
  // @HiveField(3)
  String poster_path;
  // @HiveField(4)
  num id;
  // @HiveField(5)
  bool adult;
  // @HiveField(6)
  String backdrop_path;
  // @HiveField(7)
  String original_language;
  // @HiveField(8)
  String original_title;
  // @HiveField(9)
  List genre_ids;
  // @HiveField(10)
  String title;
  // @HiveField(11)
  num vote_average;
  // @HiveField(12)
  String overview;
  // @HiveField(13)
  String release_date;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
