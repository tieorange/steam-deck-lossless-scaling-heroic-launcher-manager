import 'package:json_annotation/json_annotation.dart';

part 'game_config_model.g.dart';

/// Model for Heroic game config JSON files
@JsonSerializable()
class GameConfigModel {
  @JsonKey(name: 'app_name')
  final String? appName;
  
  final String? title;
  
  @JsonKey(name: 'enviromentOptions')
  final Map<String, dynamic>? environmentOptions;
  
  // Some configs have 'environment' directly, some have it nested
  final Map<String, dynamic>? environment;
  
  GameConfigModel({
    this.appName,
    this.title,
    this.environmentOptions,
    this.environment,
  });
  
  factory GameConfigModel.fromJson(Map<String, dynamic> json) =>
      _$GameConfigModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$GameConfigModelToJson(this);
  
  /// Check if LSFG environment variable is set
  bool get hasLsfgEnabled {
    // Check in environment
    if (environment != null && environment!.containsKey('LSFG_PROCESS')) {
      return true;
    }
    // Check in enviromentOptions (typo is intentional - Heroic uses this spelling)
    if (environmentOptions != null && environmentOptions!.containsKey('LSFG_PROCESS')) {
      return true;
    }
    return false;
  }
  
  /// Get display title, fall back to app_name if title is null
  String get displayTitle => title ?? appName ?? 'Unknown Game';
}
