import 'package:json_annotation/json_annotation.dart';
part 'model.g.dart';

@JsonSerializable()
class RandomPhoto {
  String id;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(ignore: true)
  String description;
  @JsonKey(required: true, name: 'alt_description')
  String alternativeDescription;
  List<Url> urls;

  RandomPhoto({this.urls});

  factory RandomPhoto.fromJson(Map<String, dynamic> json) =>
      _$RandomPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$RandomPhotoToJson(this);
}

@JsonSerializable()
class Url {
  String thumb;
  String full;
  Url({this.thumb, this.full});
  factory Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);
  Map<String, dynamic> toJson() => _$UrlToJson(this);
}
