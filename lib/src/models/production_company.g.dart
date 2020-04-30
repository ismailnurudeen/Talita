// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Production_company _$Production_companyFromJson(Map<String, dynamic> json) {
  return Production_company()
    ..id = json['id'] as num
    ..logo_path = json['logo_path'] as String
    ..name = json['name'] as String
    ..origin_country = json['origin_country'] as String;
}

Map<String, dynamic> _$Production_companyToJson(Production_company instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo_path': instance.logo_path,
      'name': instance.name,
      'origin_country': instance.origin_country
    };
