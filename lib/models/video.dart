import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable()
class Video {
    Video();

    String id;
    String iso_639_1;
    String iso_3166_1;
    String key;
    String name;
    String site;
    num size;
    String type;
    
    factory Video.fromJson(Map<String,dynamic> json) => _$VideoFromJson(json);
    Map<String, dynamic> toJson() => _$VideoToJson(this);
}
