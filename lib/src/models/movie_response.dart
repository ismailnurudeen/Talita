import 'package:json_annotation/json_annotation.dart';
import "movie.dart";
part 'movie_response.g.dart';

@JsonSerializable()
class Movie_response {
    Movie_response();

    num page;
    num total_results;
    num total_pages;
    List<Movie> results;
    
    factory Movie_response.fromJson(Map<String,dynamic> json) => _$Movie_responseFromJson(json);
    Map<String, dynamic> toJson() => _$Movie_responseToJson(this);
}
