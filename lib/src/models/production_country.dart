import 'package:json_annotation/json_annotation.dart';

part 'production_country.g.dart';

@JsonSerializable()
class Production_country {
    Production_country();

    String iso_3166_1;
    String name;
    
    factory Production_country.fromJson(Map<String,dynamic> json) => _$Production_countryFromJson(json);
    Map<String, dynamic> toJson() => _$Production_countryToJson(this);
}
