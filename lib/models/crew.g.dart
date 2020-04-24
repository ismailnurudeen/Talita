// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Crew _$CrewFromJson(Map<String, dynamic> json) {
  return Crew()
    ..credit_id = json['credit_id'] as String
    ..department = json['department'] as String
    ..gender = json['gender'] as num
    ..id = json['id'] as num
    ..job = json['job'] as String
    ..name = json['name'] as String
    ..profile_path = json['profile_path'] as String;
}

Map<String, dynamic> _$CrewToJson(Crew instance) => <String, dynamic>{
      'credit_id': instance.credit_id,
      'department': instance.department,
      'gender': instance.gender,
      'id': instance.id,
      'job': instance.job,
      'name': instance.name,
      'profile_path': instance.profile_path
    };
