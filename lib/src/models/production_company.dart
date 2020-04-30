import 'package:json_annotation/json_annotation.dart';

part 'production_company.g.dart';

@JsonSerializable()
class Production_company {
    Production_company();

    num id;
    String logo_path;
    String name;
    String origin_country;
    
    factory Production_company.fromJson(Map<String,dynamic> json) => _$Production_companyFromJson(json);
    Map<String, dynamic> toJson() => _$Production_companyToJson(this);
}
