import 'package:json_annotation/json_annotation.dart';

part 'spoken_language.g.dart';

@JsonSerializable()
class Spoken_language {
    Spoken_language();

    String iso_639_1;
    String name;
    
    factory Spoken_language.fromJson(Map<String,dynamic> json) => _$Spoken_languageFromJson(json);
    Map<String, dynamic> toJson() => _$Spoken_languageToJson(this);
}
