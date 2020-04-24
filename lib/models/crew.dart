import 'package:json_annotation/json_annotation.dart';

part 'crew.g.dart';

@JsonSerializable()
class Crew {
    Crew();

    String credit_id;
    String department;
    num gender;
    num id;
    String job;
    String name;
    String profile_path;
    
    factory Crew.fromJson(Map<String,dynamic> json) => _$CrewFromJson(json);
    Map<String, dynamic> toJson() => _$CrewToJson(this);
}
