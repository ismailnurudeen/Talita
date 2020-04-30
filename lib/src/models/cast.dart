import 'package:json_annotation/json_annotation.dart';

part 'cast.g.dart';

@JsonSerializable()
class Cast {
    Cast();

    num cast_id;
    String character;
    String credit_id;
    num gender;
    num id;
    String name;
    num order;
    String profile_path;
    
    factory Cast.fromJson(Map<String,dynamic> json) => _$CastFromJson(json);
    Map<String, dynamic> toJson() => _$CastToJson(this);
}
