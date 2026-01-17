// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateInfoImpl _$$UpdateInfoImplFromJson(Map<String, dynamic> json) =>
    _$UpdateInfoImpl(
      version: json['version'] as String,
      releaseNotes: json['releaseNotes'] as String,
      downloadUrl: json['downloadUrl'] as String,
      downloadSize: (json['downloadSize'] as num?)?.toInt(),
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
      isPrerelease: json['isPrerelease'] as bool? ?? false,
    );

Map<String, dynamic> _$$UpdateInfoImplToJson(_$UpdateInfoImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'releaseNotes': instance.releaseNotes,
      'downloadUrl': instance.downloadUrl,
      'downloadSize': instance.downloadSize,
      'releaseDate': instance.releaseDate?.toIso8601String(),
      'isPrerelease': instance.isPrerelease,
    };
