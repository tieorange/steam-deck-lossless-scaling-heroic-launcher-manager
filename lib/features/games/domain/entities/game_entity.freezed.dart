// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Game {
  /// Unique game identifier (from app_name in JSON)
  String get appName => throw _privateConstructorUsedError;

  /// Display title of the game
  String get title => throw _privateConstructorUsedError;

  /// Path to cached game icon (may be null)
  String? get iconPath => throw _privateConstructorUsedError;

  /// Whether LSFG environment variable is already set
  bool get hasLsfgEnabled => throw _privateConstructorUsedError;

  /// Whether this game is selected in the UI
  bool get isSelected => throw _privateConstructorUsedError;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameCopyWith<Game> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) then) =
      _$GameCopyWithImpl<$Res, Game>;
  @useResult
  $Res call({
    String appName,
    String title,
    String? iconPath,
    bool hasLsfgEnabled,
    bool isSelected,
  });
}

/// @nodoc
class _$GameCopyWithImpl<$Res, $Val extends Game>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appName = null,
    Object? title = null,
    Object? iconPath = freezed,
    Object? hasLsfgEnabled = null,
    Object? isSelected = null,
  }) {
    return _then(
      _value.copyWith(
            appName: null == appName
                ? _value.appName
                : appName // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            iconPath: freezed == iconPath
                ? _value.iconPath
                : iconPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasLsfgEnabled: null == hasLsfgEnabled
                ? _value.hasLsfgEnabled
                : hasLsfgEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSelected: null == isSelected
                ? _value.isSelected
                : isSelected // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameImplCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$$GameImplCopyWith(
    _$GameImpl value,
    $Res Function(_$GameImpl) then,
  ) = __$$GameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String appName,
    String title,
    String? iconPath,
    bool hasLsfgEnabled,
    bool isSelected,
  });
}

/// @nodoc
class __$$GameImplCopyWithImpl<$Res>
    extends _$GameCopyWithImpl<$Res, _$GameImpl>
    implements _$$GameImplCopyWith<$Res> {
  __$$GameImplCopyWithImpl(_$GameImpl _value, $Res Function(_$GameImpl) _then)
    : super(_value, _then);

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appName = null,
    Object? title = null,
    Object? iconPath = freezed,
    Object? hasLsfgEnabled = null,
    Object? isSelected = null,
  }) {
    return _then(
      _$GameImpl(
        appName: null == appName
            ? _value.appName
            : appName // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        iconPath: freezed == iconPath
            ? _value.iconPath
            : iconPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasLsfgEnabled: null == hasLsfgEnabled
            ? _value.hasLsfgEnabled
            : hasLsfgEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSelected: null == isSelected
            ? _value.isSelected
            : isSelected // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GameImpl implements _Game {
  const _$GameImpl({
    required this.appName,
    required this.title,
    this.iconPath,
    required this.hasLsfgEnabled,
    this.isSelected = false,
  });

  /// Unique game identifier (from app_name in JSON)
  @override
  final String appName;

  /// Display title of the game
  @override
  final String title;

  /// Path to cached game icon (may be null)
  @override
  final String? iconPath;

  /// Whether LSFG environment variable is already set
  @override
  final bool hasLsfgEnabled;

  /// Whether this game is selected in the UI
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'Game(appName: $appName, title: $title, iconPath: $iconPath, hasLsfgEnabled: $hasLsfgEnabled, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameImpl &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath) &&
            (identical(other.hasLsfgEnabled, hasLsfgEnabled) ||
                other.hasLsfgEnabled == hasLsfgEnabled) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    appName,
    title,
    iconPath,
    hasLsfgEnabled,
    isSelected,
  );

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      __$$GameImplCopyWithImpl<_$GameImpl>(this, _$identity);
}

abstract class _Game implements Game {
  const factory _Game({
    required final String appName,
    required final String title,
    final String? iconPath,
    required final bool hasLsfgEnabled,
    final bool isSelected,
  }) = _$GameImpl;

  /// Unique game identifier (from app_name in JSON)
  @override
  String get appName;

  /// Display title of the game
  @override
  String get title;

  /// Path to cached game icon (may be null)
  @override
  String? get iconPath;

  /// Whether LSFG environment variable is already set
  @override
  bool get hasLsfgEnabled;

  /// Whether this game is selected in the UI
  @override
  bool get isSelected;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
