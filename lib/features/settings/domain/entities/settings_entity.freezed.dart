// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Settings {
  /// Current theme mode
  ThemeMode get themeMode => throw _privateConstructorUsedError;

  /// Whether to automatically backup before applying LSFG
  bool get autoBackup => throw _privateConstructorUsedError;

  /// Whether to show confirmation dialogs for actions
  bool get showConfirmations => throw _privateConstructorUsedError;

  /// Whether to check for updates on app startup
  bool get checkForUpdatesOnStartup => throw _privateConstructorUsedError;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsCopyWith<Settings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) then) =
      _$SettingsCopyWithImpl<$Res, Settings>;
  @useResult
  $Res call({
    ThemeMode themeMode,
    bool autoBackup,
    bool showConfirmations,
    bool checkForUpdatesOnStartup,
  });
}

/// @nodoc
class _$SettingsCopyWithImpl<$Res, $Val extends Settings>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? autoBackup = null,
    Object? showConfirmations = null,
    Object? checkForUpdatesOnStartup = null,
  }) {
    return _then(
      _value.copyWith(
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as ThemeMode,
            autoBackup: null == autoBackup
                ? _value.autoBackup
                : autoBackup // ignore: cast_nullable_to_non_nullable
                      as bool,
            showConfirmations: null == showConfirmations
                ? _value.showConfirmations
                : showConfirmations // ignore: cast_nullable_to_non_nullable
                      as bool,
            checkForUpdatesOnStartup: null == checkForUpdatesOnStartup
                ? _value.checkForUpdatesOnStartup
                : checkForUpdatesOnStartup // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettingsImplCopyWith<$Res>
    implements $SettingsCopyWith<$Res> {
  factory _$$SettingsImplCopyWith(
    _$SettingsImpl value,
    $Res Function(_$SettingsImpl) then,
  ) = __$$SettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ThemeMode themeMode,
    bool autoBackup,
    bool showConfirmations,
    bool checkForUpdatesOnStartup,
  });
}

/// @nodoc
class __$$SettingsImplCopyWithImpl<$Res>
    extends _$SettingsCopyWithImpl<$Res, _$SettingsImpl>
    implements _$$SettingsImplCopyWith<$Res> {
  __$$SettingsImplCopyWithImpl(
    _$SettingsImpl _value,
    $Res Function(_$SettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? autoBackup = null,
    Object? showConfirmations = null,
    Object? checkForUpdatesOnStartup = null,
  }) {
    return _then(
      _$SettingsImpl(
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
        autoBackup: null == autoBackup
            ? _value.autoBackup
            : autoBackup // ignore: cast_nullable_to_non_nullable
                  as bool,
        showConfirmations: null == showConfirmations
            ? _value.showConfirmations
            : showConfirmations // ignore: cast_nullable_to_non_nullable
                  as bool,
        checkForUpdatesOnStartup: null == checkForUpdatesOnStartup
            ? _value.checkForUpdatesOnStartup
            : checkForUpdatesOnStartup // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SettingsImpl implements _Settings {
  const _$SettingsImpl({
    this.themeMode = ThemeMode.system,
    this.autoBackup = true,
    this.showConfirmations = true,
    this.checkForUpdatesOnStartup = true,
  });

  /// Current theme mode
  @override
  @JsonKey()
  final ThemeMode themeMode;

  /// Whether to automatically backup before applying LSFG
  @override
  @JsonKey()
  final bool autoBackup;

  /// Whether to show confirmation dialogs for actions
  @override
  @JsonKey()
  final bool showConfirmations;

  /// Whether to check for updates on app startup
  @override
  @JsonKey()
  final bool checkForUpdatesOnStartup;

  @override
  String toString() {
    return 'Settings(themeMode: $themeMode, autoBackup: $autoBackup, showConfirmations: $showConfirmations, checkForUpdatesOnStartup: $checkForUpdatesOnStartup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.autoBackup, autoBackup) ||
                other.autoBackup == autoBackup) &&
            (identical(other.showConfirmations, showConfirmations) ||
                other.showConfirmations == showConfirmations) &&
            (identical(
                  other.checkForUpdatesOnStartup,
                  checkForUpdatesOnStartup,
                ) ||
                other.checkForUpdatesOnStartup == checkForUpdatesOnStartup));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    themeMode,
    autoBackup,
    showConfirmations,
    checkForUpdatesOnStartup,
  );

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      __$$SettingsImplCopyWithImpl<_$SettingsImpl>(this, _$identity);
}

abstract class _Settings implements Settings {
  const factory _Settings({
    final ThemeMode themeMode,
    final bool autoBackup,
    final bool showConfirmations,
    final bool checkForUpdatesOnStartup,
  }) = _$SettingsImpl;

  /// Current theme mode
  @override
  ThemeMode get themeMode;

  /// Whether to automatically backup before applying LSFG
  @override
  bool get autoBackup;

  /// Whether to show confirmation dialogs for actions
  @override
  bool get showConfirmations;

  /// Whether to check for updates on app startup
  @override
  bool get checkForUpdatesOnStartup;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
