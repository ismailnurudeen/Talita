// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie_response _$Movie_responseFromJson(Map<String, dynamic> json) {
  return Movie_response()
    ..page = json['page'] as num
    ..total_results = json['total_results'] as num
    ..total_pages = json['total_pages'] as num
    ..results = (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Movie.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$Movie_responseToJson(Movie_response instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total_results': instance.total_results,
      'total_pages': instance.total_pages,
      'results': instance.results
    };
