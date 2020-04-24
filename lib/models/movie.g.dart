// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie()
    ..popularity = json['popularity'] as num
    ..vote_count = json['vote_count'] as num
    ..video = json['video'] as bool
    ..poster_path = json['poster_path'] as String
    ..id = json['id'] as num
    ..adult = json['adult'] as bool
    ..backdrop_path = json['backdrop_path'] as String
    ..original_language = json['original_language'] as String
    ..original_title = json['original_title'] as String
    ..genre_ids = json['genre_ids'] as List
    ..title = json['title'] as String
    ..vote_average = json['vote_average'] as num
    ..overview = json['overview'] as String
    ..release_date = json['release_date'] as String;
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'popularity': instance.popularity,
      'vote_count': instance.vote_count,
      'video': instance.video,
      'poster_path': instance.poster_path,
      'id': instance.id,
      'adult': instance.adult,
      'backdrop_path': instance.backdrop_path,
      'original_language': instance.original_language,
      'original_title': instance.original_title,
      'genre_ids': instance.genre_ids,
      'title': instance.title,
      'vote_average': instance.vote_average,
      'overview': instance.overview,
      'release_date': instance.release_date
    };
