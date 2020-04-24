// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video_response _$Video_responseFromJson(Map<String, dynamic> json) {
  return Video_response()
    ..id = json['id'] as num
    ..results = (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Video.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$Video_responseToJson(Video_response instance) =>
    <String, dynamic>{'id': instance.id, 'results': instance.results};
