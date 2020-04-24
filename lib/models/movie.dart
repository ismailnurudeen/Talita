import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
    Movie();

    num popularity;
    num vote_count;
    bool video;
    String poster_path;
    num id;
    bool adult;
    String backdrop_path;
    String original_language;
    String original_title;
    List genre_ids;
    String title;
    num vote_average;
    String overview;
    String release_date;
    
    factory Movie.fromJson(Map<String,dynamic> json) => _$MovieFromJson(json);
    Map<String, dynamic> toJson() => _$MovieToJson(this);
}
