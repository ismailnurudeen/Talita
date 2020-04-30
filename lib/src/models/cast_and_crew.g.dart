// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_and_crew.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cast_and_crew _$Cast_and_crewFromJson(Map<String, dynamic> json) {
  return Cast_and_crew()
    ..id = json['id'] as num
    ..cast = (json['cast'] as List)
        ?.map(
            (e) => e == null ? null : Cast.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..crew = (json['crew'] as List)
        ?.map(
            (e) => e == null ? null : Crew.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$Cast_and_crewToJson(Cast_and_crew instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast,
      'crew': instance.crew
    };
