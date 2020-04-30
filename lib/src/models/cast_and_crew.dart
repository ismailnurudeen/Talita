import 'package:json_annotation/json_annotation.dart';
import "cast.dart";
import "crew.dart";
part 'cast_and_crew.g.dart';

@JsonSerializable()
class Cast_and_crew {
    Cast_and_crew();

    num id;
    List<Cast> cast;
    List<Crew> crew;
    
    factory Cast_and_crew.fromJson(Map<String,dynamic> json) => _$Cast_and_crewFromJson(json);
    Map<String, dynamic> toJson() => _$Cast_and_crewToJson(this);
}
