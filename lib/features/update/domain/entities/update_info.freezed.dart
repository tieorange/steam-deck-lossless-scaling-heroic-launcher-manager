// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdateInfo _$UpdateInfoFromJson(Map<String, dynamic> json) {
  return _UpdateInfo.fromJson(json);
}

/// @nodoc
mixin _$UpdateInfo {
  /// Version tag (e.g., "v1.0.1" or "1.0.1")
  String get version => throw _privateConstructorUsedError;

  /// Release notes / changelog
  String get releaseNotes => throw _privateConstructorUsedError;

  /// Download URL for the Linux release asset
  String get downloadUrl => throw _privateConstructorUsedError;

  /// Size of the download in bytes (if available)
  int? get downloadSize => throw _privateConstructorUsedError;

  /// Release date
  DateTime? get releaseDate => throw _privateConstructorUsedError;

  /// Whether this is a prerelease
  bool get isPrerelease => throw _privateConstructorUsedError;

  /// Serializes this UpdateInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateInfoCopyWith<UpdateInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateInfoCopyWith<$Res> {
  factory $UpdateInfoCopyWith(
    UpdateInfo value,
    $Res Function(UpdateInfo) then,
  ) = _$UpdateInfoCopyWithImpl<$Res, UpdateInfo>;
  @useResult
  $Res call({
    String version,
    String releaseNotes,
    String downloadUrl,
    int? downloadSize,
    DateTime? releaseDate,
    bool isPrerelease,
  });
}

/// @nodoc
class _$UpdateInfoCopyWithImpl<$Res, $Val extends UpdateInfo>
    implements $UpdateInfoCopyWith<$Res> {
  _$UpdateInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? releaseNotes = null,
    Object? downloadUrl = null,
    Object? downloadSize = freezed,
    Object? releaseDate = freezed,
    Object? isPrerelease = null,
  }) {
    return _then(
      _value.copyWith(
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            releaseNotes: null == releaseNotes
                ? _value.releaseNotes
                : releaseNotes // ignore: cast_nullable_to_non_nullable
                      as String,
            downloadUrl: null == downloadUrl
                ? _value.downloadUrl
                : downloadUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            downloadSize: freezed == downloadSize
                ? _value.downloadSize
                : downloadSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            releaseDate: freezed == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isPrerelease: null == isPrerelease
                ? _value.isPrerelease
                : isPrerelease // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateInfoImplCopyWith<$Res>
    implements $UpdateInfoCopyWith<$Res> {
  factory _$$UpdateInfoImplCopyWith(
    _$UpdateInfoImpl value,
    $Res Function(_$UpdateInfoImpl) then,
  ) = __$$UpdateInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String version,
    String releaseNotes,
    String downloadUrl,
    int? downloadSize,
    DateTime? releaseDate,
    bool isPrerelease,
  });
}

/// @nodoc
class __$$UpdateInfoImplCopyWithImpl<$Res>
    extends _$UpdateInfoCopyWithImpl<$Res, _$UpdateInfoImpl>
    implements _$$UpdateInfoImplCopyWith<$Res> {
  __$$UpdateInfoImplCopyWithImpl(
    _$UpdateInfoImpl _value,
    $Res Function(_$UpdateInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? releaseNotes = null,
    Object? downloadUrl = null,
    Object? downloadSize = freezed,
    Object? releaseDate = freezed,
    Object? isPrerelease = null,
  }) {
    return _then(
      _$UpdateInfoImpl(
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        releaseNotes: null == releaseNotes
            ? _value.releaseNotes
            : releaseNotes // ignore: cast_nullable_to_non_nullable
                  as String,
        downloadUrl: null == downloadUrl
            ? _value.downloadUrl
            : downloadUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        downloadSize: freezed == downloadSize
            ? _value.downloadSize
            : downloadSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        releaseDate: freezed == releaseDate
            ? _value.releaseDate
            : releaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isPrerelease: null == isPrerelease
            ? _value.isPrerelease
            : isPrerelease // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateInfoImpl implements _UpdateInfo {
  const _$UpdateInfoImpl({
    required this.version,
    required this.releaseNotes,
    required this.downloadUrl,
    this.downloadSize,
    this.releaseDate,
    this.isPrerelease = false,
  });

  factory _$UpdateInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateInfoImplFromJson(json);

  /// Version tag (e.g., "v1.0.1" or "1.0.1")
  @override
  final String version;

  /// Release notes / changelog
  @override
  final String releaseNotes;

  /// Download URL for the Linux release asset
  @override
  final String downloadUrl;

  /// Size of the download in bytes (if available)
  @override
  final int? downloadSize;

  /// Release date
  @override
  final DateTime? releaseDate;

  /// Whether this is a prerelease
  @override
  @JsonKey()
  final bool isPrerelease;

  @override
  String toString() {
    return 'UpdateInfo(version: $version, releaseNotes: $releaseNotes, downloadUrl: $downloadUrl, downloadSize: $downloadSize, releaseDate: $releaseDate, isPrerelease: $isPrerelease)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateInfoImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.releaseNotes, releaseNotes) ||
                other.releaseNotes == releaseNotes) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.downloadSize, downloadSize) ||
                other.downloadSize == downloadSize) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.isPrerelease, isPrerelease) ||
                other.isPrerelease == isPrerelease));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    version,
    releaseNotes,
    downloadUrl,
    downloadSize,
    releaseDate,
    isPrerelease,
  );

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateInfoImplCopyWith<_$UpdateInfoImpl> get copyWith =>
      __$$UpdateInfoImplCopyWithImpl<_$UpdateInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateInfoImplToJson(this);
  }
}

abstract class _UpdateInfo implements UpdateInfo {
  const factory _UpdateInfo({
    required final String version,
    required final String releaseNotes,
    required final String downloadUrl,
    final int? downloadSize,
    final DateTime? releaseDate,
    final bool isPrerelease,
  }) = _$UpdateInfoImpl;

  factory _UpdateInfo.fromJson(Map<String, dynamic> json) =
      _$UpdateInfoImpl.fromJson;

  /// Version tag (e.g., "v1.0.1" or "1.0.1")
  @override
  String get version;

  /// Release notes / changelog
  @override
  String get releaseNotes;

  /// Download URL for the Linux release asset
  @override
  String get downloadUrl;

  /// Size of the download in bytes (if available)
  @override
  int? get downloadSize;

  /// Release date
  @override
  DateTime? get releaseDate;

  /// Whether this is a prerelease
  @override
  bool get isPrerelease;

  /// Create a copy of UpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateInfoImplCopyWith<_$UpdateInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateCheckResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UpdateInfo info) available,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UpdateInfo info)? available,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateAvailable value) available,
    required TResult Function(UpToDate value) upToDate,
    required TResult Function(UpdateError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateAvailable value)? available,
    TResult? Function(UpToDate value)? upToDate,
    TResult? Function(UpdateError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateAvailable value)? available,
    TResult Function(UpToDate value)? upToDate,
    TResult Function(UpdateError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCheckResultCopyWith<$Res> {
  factory $UpdateCheckResultCopyWith(
    UpdateCheckResult value,
    $Res Function(UpdateCheckResult) then,
  ) = _$UpdateCheckResultCopyWithImpl<$Res, UpdateCheckResult>;
}

/// @nodoc
class _$UpdateCheckResultCopyWithImpl<$Res, $Val extends UpdateCheckResult>
    implements $UpdateCheckResultCopyWith<$Res> {
  _$UpdateCheckResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UpdateAvailableImplCopyWith<$Res> {
  factory _$$UpdateAvailableImplCopyWith(
    _$UpdateAvailableImpl value,
    $Res Function(_$UpdateAvailableImpl) then,
  ) = __$$UpdateAvailableImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UpdateInfo info});

  $UpdateInfoCopyWith<$Res> get info;
}

/// @nodoc
class __$$UpdateAvailableImplCopyWithImpl<$Res>
    extends _$UpdateCheckResultCopyWithImpl<$Res, _$UpdateAvailableImpl>
    implements _$$UpdateAvailableImplCopyWith<$Res> {
  __$$UpdateAvailableImplCopyWithImpl(
    _$UpdateAvailableImpl _value,
    $Res Function(_$UpdateAvailableImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? info = null}) {
    return _then(
      _$UpdateAvailableImpl(
        null == info
            ? _value.info
            : info // ignore: cast_nullable_to_non_nullable
                  as UpdateInfo,
      ),
    );
  }

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateInfoCopyWith<$Res> get info {
    return $UpdateInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value));
    });
  }
}

/// @nodoc

class _$UpdateAvailableImpl implements UpdateAvailable {
  const _$UpdateAvailableImpl(this.info);

  @override
  final UpdateInfo info;

  @override
  String toString() {
    return 'UpdateCheckResult.available(info: $info)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateAvailableImpl &&
            (identical(other.info, info) || other.info == info));
  }

  @override
  int get hashCode => Object.hash(runtimeType, info);

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateAvailableImplCopyWith<_$UpdateAvailableImpl> get copyWith =>
      __$$UpdateAvailableImplCopyWithImpl<_$UpdateAvailableImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UpdateInfo info) available,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) {
    return available(info);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) {
    return available?.call(info);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UpdateInfo info)? available,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (available != null) {
      return available(info);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateAvailable value) available,
    required TResult Function(UpToDate value) upToDate,
    required TResult Function(UpdateError value) error,
  }) {
    return available(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateAvailable value)? available,
    TResult? Function(UpToDate value)? upToDate,
    TResult? Function(UpdateError value)? error,
  }) {
    return available?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateAvailable value)? available,
    TResult Function(UpToDate value)? upToDate,
    TResult Function(UpdateError value)? error,
    required TResult orElse(),
  }) {
    if (available != null) {
      return available(this);
    }
    return orElse();
  }
}

abstract class UpdateAvailable implements UpdateCheckResult {
  const factory UpdateAvailable(final UpdateInfo info) = _$UpdateAvailableImpl;

  UpdateInfo get info;

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateAvailableImplCopyWith<_$UpdateAvailableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpToDateImplCopyWith<$Res> {
  factory _$$UpToDateImplCopyWith(
    _$UpToDateImpl value,
    $Res Function(_$UpToDateImpl) then,
  ) = __$$UpToDateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String currentVersion});
}

/// @nodoc
class __$$UpToDateImplCopyWithImpl<$Res>
    extends _$UpdateCheckResultCopyWithImpl<$Res, _$UpToDateImpl>
    implements _$$UpToDateImplCopyWith<$Res> {
  __$$UpToDateImplCopyWithImpl(
    _$UpToDateImpl _value,
    $Res Function(_$UpToDateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentVersion = null}) {
    return _then(
      _$UpToDateImpl(
        null == currentVersion
            ? _value.currentVersion
            : currentVersion // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpToDateImpl implements UpToDate {
  const _$UpToDateImpl(this.currentVersion);

  @override
  final String currentVersion;

  @override
  String toString() {
    return 'UpdateCheckResult.upToDate(currentVersion: $currentVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpToDateImpl &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentVersion);

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpToDateImplCopyWith<_$UpToDateImpl> get copyWith =>
      __$$UpToDateImplCopyWithImpl<_$UpToDateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UpdateInfo info) available,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) {
    return upToDate(currentVersion);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) {
    return upToDate?.call(currentVersion);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UpdateInfo info)? available,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (upToDate != null) {
      return upToDate(currentVersion);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateAvailable value) available,
    required TResult Function(UpToDate value) upToDate,
    required TResult Function(UpdateError value) error,
  }) {
    return upToDate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateAvailable value)? available,
    TResult? Function(UpToDate value)? upToDate,
    TResult? Function(UpdateError value)? error,
  }) {
    return upToDate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateAvailable value)? available,
    TResult Function(UpToDate value)? upToDate,
    TResult Function(UpdateError value)? error,
    required TResult orElse(),
  }) {
    if (upToDate != null) {
      return upToDate(this);
    }
    return orElse();
  }
}

abstract class UpToDate implements UpdateCheckResult {
  const factory UpToDate(final String currentVersion) = _$UpToDateImpl;

  String get currentVersion;

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpToDateImplCopyWith<_$UpToDateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateErrorImplCopyWith<$Res> {
  factory _$$UpdateErrorImplCopyWith(
    _$UpdateErrorImpl value,
    $Res Function(_$UpdateErrorImpl) then,
  ) = __$$UpdateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UpdateErrorImplCopyWithImpl<$Res>
    extends _$UpdateCheckResultCopyWithImpl<$Res, _$UpdateErrorImpl>
    implements _$$UpdateErrorImplCopyWith<$Res> {
  __$$UpdateErrorImplCopyWithImpl(
    _$UpdateErrorImpl _value,
    $Res Function(_$UpdateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UpdateErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateErrorImpl implements UpdateError {
  const _$UpdateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'UpdateCheckResult.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateErrorImplCopyWith<_$UpdateErrorImpl> get copyWith =>
      __$$UpdateErrorImplCopyWithImpl<_$UpdateErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UpdateInfo info) available,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UpdateInfo info)? available,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UpdateInfo info)? available,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateAvailable value) available,
    required TResult Function(UpToDate value) upToDate,
    required TResult Function(UpdateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateAvailable value)? available,
    TResult? Function(UpToDate value)? upToDate,
    TResult? Function(UpdateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateAvailable value)? available,
    TResult Function(UpToDate value)? upToDate,
    TResult Function(UpdateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class UpdateError implements UpdateCheckResult {
  const factory UpdateError(final String message) = _$UpdateErrorImpl;

  String get message;

  /// Create a copy of UpdateCheckResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateErrorImplCopyWith<_$UpdateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateProgress {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int bytesReceived, int totalBytes) downloading,
    required TResult Function() extracting,
    required TResult Function() installing,
    required TResult Function() completed,
    required TResult Function(String message) failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int bytesReceived, int totalBytes)? downloading,
    TResult? Function()? extracting,
    TResult? Function()? installing,
    TResult? Function()? completed,
    TResult? Function(String message)? failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int bytesReceived, int totalBytes)? downloading,
    TResult Function()? extracting,
    TResult Function()? installing,
    TResult Function()? completed,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Downloading value) downloading,
    required TResult Function(Extracting value) extracting,
    required TResult Function(Installing value) installing,
    required TResult Function(UpdateCompleted value) completed,
    required TResult Function(UpdateFailed value) failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Downloading value)? downloading,
    TResult? Function(Extracting value)? extracting,
    TResult? Function(Installing value)? installing,
    TResult? Function(UpdateCompleted value)? completed,
    TResult? Function(UpdateFailed value)? failed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Downloading value)? downloading,
    TResult Function(Extracting value)? extracting,
    TResult Function(Installing value)? installing,
    TResult Function(UpdateCompleted value)? completed,
    TResult Function(UpdateFailed value)? failed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProgressCopyWith<$Res> {
  factory $UpdateProgressCopyWith(
    UpdateProgress value,
    $Res Function(UpdateProgress) then,
  ) = _$UpdateProgressCopyWithImpl<$Res, UpdateProgress>;
}

/// @nodoc
class _$UpdateProgressCopyWithImpl<$Res, $Val extends UpdateProgress>
    implements $UpdateProgressCopyWith<$Res> {
  _$UpdateProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DownloadingImplCopyWith<$Res> {
  factory _$$DownloadingImplCopyWith(
    _$DownloadingImpl value,
    $Res Function(_$DownloadingImpl) then,
  ) = __$$DownloadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int bytesReceived, int totalBytes});
}

/// @nodoc
class __$$DownloadingImplCopyWithImpl<$Res>
    extends _$UpdateProgressCopyWithImpl<$Res, _$DownloadingImpl>
    implements _$$DownloadingImplCopyWith<$Res> {
  __$$DownloadingImplCopyWithImpl(
    _$DownloadingImpl _value,
    $Res Function(_$DownloadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bytesReceived = null, Object? totalBytes = null}) {
    return _then(
      _$DownloadingImpl(
        bytesReceived: null == bytesReceived
            ? _value.bytesReceived
            : bytesReceived // ignore: cast_nullable_to_non_nullable
                  as int,
        totalBytes: null == totalBytes
            ? _value.totalBytes
            : totalBytes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DownloadingImpl implements Downloading {
  const _$DownloadingImpl({
    required this.bytesReceived,
    required this.totalBytes,
  });

  @override
  final int bytesReceived;
  @override
  final int totalBytes;

  @override
  String toString() {
    return 'UpdateProgress.downloading(bytesReceived: $bytesReceived, totalBytes: $totalBytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadingImpl &&
            (identical(other.bytesReceived, bytesReceived) ||
                other.bytesReceived == bytesReceived) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bytesReceived, totalBytes);

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadingImplCopyWith<_$DownloadingImpl> get copyWith =>
      __$$DownloadingImplCopyWithImpl<_$DownloadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int bytesReceived, int totalBytes) downloading,
    required TResult Function() extracting,
    required TResult Function() installing,
    required TResult Function() completed,
    required TResult Function(String message) failed,
  }) {
    return downloading(bytesReceived, totalBytes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int bytesReceived, int totalBytes)? downloading,
    TResult? Function()? extracting,
    TResult? Function()? installing,
    TResult? Function()? completed,
    TResult? Function(String message)? failed,
  }) {
    return downloading?.call(bytesReceived, totalBytes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int bytesReceived, int totalBytes)? downloading,
    TResult Function()? extracting,
    TResult Function()? installing,
    TResult Function()? completed,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading(bytesReceived, totalBytes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Downloading value) downloading,
    required TResult Function(Extracting value) extracting,
    required TResult Function(Installing value) installing,
    required TResult Function(UpdateCompleted value) completed,
    required TResult Function(UpdateFailed value) failed,
  }) {
    return downloading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Downloading value)? downloading,
    TResult? Function(Extracting value)? extracting,
    TResult? Function(Installing value)? installing,
    TResult? Function(UpdateCompleted value)? completed,
    TResult? Function(UpdateFailed value)? failed,
  }) {
    return downloading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Downloading value)? downloading,
    TResult Function(Extracting value)? extracting,
    TResult Function(Installing value)? installing,
    TResult Function(UpdateCompleted value)? completed,
    TResult Function(UpdateFailed value)? failed,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading(this);
    }
    return orElse();
  }
}

abstract class Downloading implements UpdateProgress {
  const factory Downloading({
    required final int bytesReceived,
    required final int totalBytes,
  }) = _$DownloadingImpl;

  int get bytesReceived;
  int get totalBytes;

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DownloadingImplCopyWith<_$DownloadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExtractingImplCopyWith<$Res> {
  factory _$$ExtractingImplCopyWith(
    _$ExtractingImpl value,
    $Res Function(_$ExtractingImpl) then,
  ) = __$$ExtractingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ExtractingImplCopyWithImpl<$Res>
    extends _$UpdateProgressCopyWithImpl<$Res, _$ExtractingImpl>
    implements _$$ExtractingImplCopyWith<$Res> {
  __$$ExtractingImplCopyWithImpl(
    _$ExtractingImpl _value,
    $Res Function(_$ExtractingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ExtractingImpl implements Extracting {
  const _$ExtractingImpl();

  @override
  String toString() {
    return 'UpdateProgress.extracting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ExtractingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int bytesReceived, int totalBytes) downloading,
    required TResult Function() extracting,
    required TResult Function() installing,
    required TResult Function() completed,
    required TResult Function(String message) failed,
  }) {
    return extracting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int bytesReceived, int totalBytes)? downloading,
    TResult? Function()? extracting,
    TResult? Function()? installing,
    TResult? Function()? completed,
    TResult? Function(String message)? failed,
  }) {
    return extracting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int bytesReceived, int totalBytes)? downloading,
    TResult Function()? extracting,
    TResult Function()? installing,
    TResult Function()? completed,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (extracting != null) {
      return extracting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Downloading value) downloading,
    required TResult Function(Extracting value) extracting,
    required TResult Function(Installing value) installing,
    required TResult Function(UpdateCompleted value) completed,
    required TResult Function(UpdateFailed value) failed,
  }) {
    return extracting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Downloading value)? downloading,
    TResult? Function(Extracting value)? extracting,
    TResult? Function(Installing value)? installing,
    TResult? Function(UpdateCompleted value)? completed,
    TResult? Function(UpdateFailed value)? failed,
  }) {
    return extracting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Downloading value)? downloading,
    TResult Function(Extracting value)? extracting,
    TResult Function(Installing value)? installing,
    TResult Function(UpdateCompleted value)? completed,
    TResult Function(UpdateFailed value)? failed,
    required TResult orElse(),
  }) {
    if (extracting != null) {
      return extracting(this);
    }
    return orElse();
  }
}

abstract class Extracting implements UpdateProgress {
  const factory Extracting() = _$ExtractingImpl;
}

/// @nodoc
abstract class _$$InstallingImplCopyWith<$Res> {
  factory _$$InstallingImplCopyWith(
    _$InstallingImpl value,
    $Res Function(_$InstallingImpl) then,
  ) = __$$InstallingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InstallingImplCopyWithImpl<$Res>
    extends _$UpdateProgressCopyWithImpl<$Res, _$InstallingImpl>
    implements _$$InstallingImplCopyWith<$Res> {
  __$$InstallingImplCopyWithImpl(
    _$InstallingImpl _value,
    $Res Function(_$InstallingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InstallingImpl implements Installing {
  const _$InstallingImpl();

  @override
  String toString() {
    return 'UpdateProgress.installing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InstallingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int bytesReceived, int totalBytes) downloading,
    required TResult Function() extracting,
    required TResult Function() installing,
    required TResult Function() completed,
    required TResult Function(String message) failed,
  }) {
    return installing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int bytesReceived, int totalBytes)? downloading,
    TResult? Function()? extracting,
    TResult? Function()? installing,
    TResult? Function()? completed,
    TResult? Function(String message)? failed,
  }) {
    return installing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int bytesReceived, int totalBytes)? downloading,
    TResult Function()? extracting,
    TResult Function()? installing,
    TResult Function()? completed,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (installing != null) {
      return installing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Downloading value) downloading,
    required TResult Function(Extracting value) extracting,
    required TResult Function(Installing value) installing,
    required TResult Function(UpdateCompleted value) completed,
    required TResult Function(UpdateFailed value) failed,
  }) {
    return installing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Downloading value)? downloading,
    TResult? Function(Extracting value)? extracting,
    TResult? Function(Installing value)? installing,
    TResult? Function(UpdateCompleted value)? completed,
    TResult? Function(UpdateFailed value)? failed,
  }) {
    return installing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Downloading value)? downloading,
    TResult Function(Extracting value)? extracting,
    TResult Function(Installing value)? installing,
    TResult Function(UpdateCompleted value)? completed,
    TResult Function(UpdateFailed value)? failed,
    required TResult orElse(),
  }) {
    if (installing != null) {
      return installing(this);
    }
    return orElse();
  }
}

abstract class Installing implements UpdateProgress {
  const factory Installing() = _$InstallingImpl;
}

/// @nodoc
abstract class _$$UpdateCompletedImplCopyWith<$Res> {
  factory _$$UpdateCompletedImplCopyWith(
    _$UpdateCompletedImpl value,
    $Res Function(_$UpdateCompletedImpl) then,
  ) = __$$UpdateCompletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdateCompletedImplCopyWithImpl<$Res>
    extends _$UpdateProgressCopyWithImpl<$Res, _$UpdateCompletedImpl>
    implements _$$UpdateCompletedImplCopyWith<$Res> {
  __$$UpdateCompletedImplCopyWithImpl(
    _$UpdateCompletedImpl _value,
    $Res Function(_$UpdateCompletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UpdateCompletedImpl implements UpdateCompleted {
  const _$UpdateCompletedImpl();

  @override
  String toString() {
    return 'UpdateProgress.completed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UpdateCompletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int bytesReceived, int totalBytes) downloading,
    required TResult Function() extracting,
    required TResult Function() installing,
    required TResult Function() completed,
    required TResult Function(String message) failed,
  }) {
    return completed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int bytesReceived, int totalBytes)? downloading,
    TResult? Function()? extracting,
    TResult? Function()? installing,
    TResult? Function()? completed,
    TResult? Function(String message)? failed,
  }) {
    return completed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int bytesReceived, int totalBytes)? downloading,
    TResult Function()? extracting,
    TResult Function()? installing,
    TResult Function()? completed,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Downloading value) downloading,
    required TResult Function(Extracting value) extracting,
    required TResult Function(Installing value) installing,
    required TResult Function(UpdateCompleted value) completed,
    required TResult Function(UpdateFailed value) failed,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Downloading value)? downloading,
    TResult? Function(Extracting value)? extracting,
    TResult? Function(Installing value)? installing,
    TResult? Function(UpdateCompleted value)? completed,
    TResult? Function(UpdateFailed value)? failed,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Downloading value)? downloading,
    TResult Function(Extracting value)? extracting,
    TResult Function(Installing value)? installing,
    TResult Function(UpdateCompleted value)? completed,
    TResult Function(UpdateFailed value)? failed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class UpdateCompleted implements UpdateProgress {
  const factory UpdateCompleted() = _$UpdateCompletedImpl;
}

/// @nodoc
abstract class _$$UpdateFailedImplCopyWith<$Res> {
  factory _$$UpdateFailedImplCopyWith(
    _$UpdateFailedImpl value,
    $Res Function(_$UpdateFailedImpl) then,
  ) = __$$UpdateFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UpdateFailedImplCopyWithImpl<$Res>
    extends _$UpdateProgressCopyWithImpl<$Res, _$UpdateFailedImpl>
    implements _$$UpdateFailedImplCopyWith<$Res> {
  __$$UpdateFailedImplCopyWithImpl(
    _$UpdateFailedImpl _value,
    $Res Function(_$UpdateFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UpdateFailedImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateFailedImpl implements UpdateFailed {
  const _$UpdateFailedImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'UpdateProgress.failed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateFailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateFailedImplCopyWith<_$UpdateFailedImpl> get copyWith =>
      __$$UpdateFailedImplCopyWithImpl<_$UpdateFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int bytesReceived, int totalBytes) downloading,
    required TResult Function() extracting,
    required TResult Function() installing,
    required TResult Function() completed,
    required TResult Function(String message) failed,
  }) {
    return failed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int bytesReceived, int totalBytes)? downloading,
    TResult? Function()? extracting,
    TResult? Function()? installing,
    TResult? Function()? completed,
    TResult? Function(String message)? failed,
  }) {
    return failed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int bytesReceived, int totalBytes)? downloading,
    TResult Function()? extracting,
    TResult Function()? installing,
    TResult Function()? completed,
    TResult Function(String message)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Downloading value) downloading,
    required TResult Function(Extracting value) extracting,
    required TResult Function(Installing value) installing,
    required TResult Function(UpdateCompleted value) completed,
    required TResult Function(UpdateFailed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Downloading value)? downloading,
    TResult? Function(Extracting value)? extracting,
    TResult? Function(Installing value)? installing,
    TResult? Function(UpdateCompleted value)? completed,
    TResult? Function(UpdateFailed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Downloading value)? downloading,
    TResult Function(Extracting value)? extracting,
    TResult Function(Installing value)? installing,
    TResult Function(UpdateCompleted value)? completed,
    TResult Function(UpdateFailed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class UpdateFailed implements UpdateProgress {
  const factory UpdateFailed(final String message) = _$UpdateFailedImpl;

  String get message;

  /// Create a copy of UpdateProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateFailedImplCopyWith<_$UpdateFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
