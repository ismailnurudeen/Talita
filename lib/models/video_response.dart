import 'package:json_annotation/json_annotation.dart';
import "video.dart";
part 'video_response.g.dart';

@JsonSerializable()
class Video_response {
    Video_response();

    num id;
    List<Video> results;
    
    factory Video_response.fromJson(Map<String,dynamic> json) => _$Video_responseFromJson(json);
    Map<String, dynamic> toJson() => _$Video_responseToJson(this);
}
