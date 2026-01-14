// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameConfigModel _$GameConfigModelFromJson(Map<String, dynamic> json) =>
    GameConfigModel(
      appName: json['app_name'] as String?,
      title: json['title'] as String?,
      environmentOptions: json['enviromentOptions'] as Map<String, dynamic>?,
      environment: json['environment'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$GameConfigModelToJson(GameConfigModel instance) =>
    <String, dynamic>{
      'app_name': instance.appName,
      'title': instance.title,
      'enviromentOptions': instance.environmentOptions,
      'environment': instance.environment,
    };
