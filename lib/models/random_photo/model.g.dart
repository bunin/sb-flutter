// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RandomPhoto _$RandomPhotoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['alt_description']);
  return RandomPhoto(
    urls: (json['urls'] as List)
        ?.map((e) => e == null ? null : Url.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..id = json['id'] as String
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String)
    ..alternativeDescription = json['alt_description'] as String;
}

Map<String, dynamic> _$RandomPhotoToJson(RandomPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'alt_description': instance.alternativeDescription,
      'urls': instance.urls,
    };

Url _$UrlFromJson(Map<String, dynamic> json) {
  return Url(
    thumb: json['thumb'] as String,
    full: json['full'] as String,
  );
}

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'thumb': instance.thumb,
      'full': instance.full,
    };
