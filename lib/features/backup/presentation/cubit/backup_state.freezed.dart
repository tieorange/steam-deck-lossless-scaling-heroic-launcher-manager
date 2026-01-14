// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BackupState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<Backup> backups,
      bool isCreating,
      bool isRestoring,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Backup> backups, bool isCreating, bool isRestoring)?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Backup> backups, bool isCreating, bool isRestoring)?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackupLoading value) loading,
    required TResult Function(BackupLoaded value) loaded,
    required TResult Function(BackupError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackupLoading value)? loading,
    TResult? Function(BackupLoaded value)? loaded,
    TResult? Function(BackupError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackupLoading value)? loading,
    TResult Function(BackupLoaded value)? loaded,
    TResult Function(BackupError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupStateCopyWith<$Res> {
  factory $BackupStateCopyWith(
    BackupState value,
    $Res Function(BackupState) then,
  ) = _$BackupStateCopyWithImpl<$Res, BackupState>;
}

/// @nodoc
class _$BackupStateCopyWithImpl<$Res, $Val extends BackupState>
    implements $BackupStateCopyWith<$Res> {
  _$BackupStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BackupLoadingImplCopyWith<$Res> {
  factory _$$BackupLoadingImplCopyWith(
    _$BackupLoadingImpl value,
    $Res Function(_$BackupLoadingImpl) then,
  ) = __$$BackupLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BackupLoadingImplCopyWithImpl<$Res>
    extends _$BackupStateCopyWithImpl<$Res, _$BackupLoadingImpl>
    implements _$$BackupLoadingImplCopyWith<$Res> {
  __$$BackupLoadingImplCopyWithImpl(
    _$BackupLoadingImpl _value,
    $Res Function(_$BackupLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BackupLoadingImpl implements BackupLoading {
  const _$BackupLoadingImpl();

  @override
  String toString() {
    return 'BackupState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BackupLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<Backup> backups,
      bool isCreating,
      bool isRestoring,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Backup> backups, bool isCreating, bool isRestoring)?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Backup> backups, bool isCreating, bool isRestoring)?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackupLoading value) loading,
    required TResult Function(BackupLoaded value) loaded,
    required TResult Function(BackupError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackupLoading value)? loading,
    TResult? Function(BackupLoaded value)? loaded,
    TResult? Function(BackupError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackupLoading value)? loading,
    TResult Function(BackupLoaded value)? loaded,
    TResult Function(BackupError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class BackupLoading implements BackupState {
  const factory BackupLoading() = _$BackupLoadingImpl;
}

/// @nodoc
abstract class _$$BackupLoadedImplCopyWith<$Res> {
  factory _$$BackupLoadedImplCopyWith(
    _$BackupLoadedImpl value,
    $Res Function(_$BackupLoadedImpl) then,
  ) = __$$BackupLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Backup> backups, bool isCreating, bool isRestoring});
}

/// @nodoc
class __$$BackupLoadedImplCopyWithImpl<$Res>
    extends _$BackupStateCopyWithImpl<$Res, _$BackupLoadedImpl>
    implements _$$BackupLoadedImplCopyWith<$Res> {
  __$$BackupLoadedImplCopyWithImpl(
    _$BackupLoadedImpl _value,
    $Res Function(_$BackupLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backups = null,
    Object? isCreating = null,
    Object? isRestoring = null,
  }) {
    return _then(
      _$BackupLoadedImpl(
        backups: null == backups
            ? _value._backups
            : backups // ignore: cast_nullable_to_non_nullable
                  as List<Backup>,
        isCreating: null == isCreating
            ? _value.isCreating
            : isCreating // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRestoring: null == isRestoring
            ? _value.isRestoring
            : isRestoring // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$BackupLoadedImpl implements BackupLoaded {
  const _$BackupLoadedImpl({
    required final List<Backup> backups,
    this.isCreating = false,
    this.isRestoring = false,
  }) : _backups = backups;

  final List<Backup> _backups;
  @override
  List<Backup> get backups {
    if (_backups is EqualUnmodifiableListView) return _backups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_backups);
  }

  @override
  @JsonKey()
  final bool isCreating;
  @override
  @JsonKey()
  final bool isRestoring;

  @override
  String toString() {
    return 'BackupState.loaded(backups: $backups, isCreating: $isCreating, isRestoring: $isRestoring)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupLoadedImpl &&
            const DeepCollectionEquality().equals(other._backups, _backups) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isRestoring, isRestoring) ||
                other.isRestoring == isRestoring));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_backups),
    isCreating,
    isRestoring,
  );

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupLoadedImplCopyWith<_$BackupLoadedImpl> get copyWith =>
      __$$BackupLoadedImplCopyWithImpl<_$BackupLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<Backup> backups,
      bool isCreating,
      bool isRestoring,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(backups, isCreating, isRestoring);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Backup> backups, bool isCreating, bool isRestoring)?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(backups, isCreating, isRestoring);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Backup> backups, bool isCreating, bool isRestoring)?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(backups, isCreating, isRestoring);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackupLoading value) loading,
    required TResult Function(BackupLoaded value) loaded,
    required TResult Function(BackupError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackupLoading value)? loading,
    TResult? Function(BackupLoaded value)? loaded,
    TResult? Function(BackupError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackupLoading value)? loading,
    TResult Function(BackupLoaded value)? loaded,
    TResult Function(BackupError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class BackupLoaded implements BackupState {
  const factory BackupLoaded({
    required final List<Backup> backups,
    final bool isCreating,
    final bool isRestoring,
  }) = _$BackupLoadedImpl;

  List<Backup> get backups;
  bool get isCreating;
  bool get isRestoring;

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupLoadedImplCopyWith<_$BackupLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BackupErrorImplCopyWith<$Res> {
  factory _$$BackupErrorImplCopyWith(
    _$BackupErrorImpl value,
    $Res Function(_$BackupErrorImpl) then,
  ) = __$$BackupErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$BackupErrorImplCopyWithImpl<$Res>
    extends _$BackupStateCopyWithImpl<$Res, _$BackupErrorImpl>
    implements _$$BackupErrorImplCopyWith<$Res> {
  __$$BackupErrorImplCopyWithImpl(
    _$BackupErrorImpl _value,
    $Res Function(_$BackupErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$BackupErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$BackupErrorImpl implements BackupError {
  const _$BackupErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'BackupState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupErrorImplCopyWith<_$BackupErrorImpl> get copyWith =>
      __$$BackupErrorImplCopyWithImpl<_$BackupErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<Backup> backups,
      bool isCreating,
      bool isRestoring,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Backup> backups, bool isCreating, bool isRestoring)?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Backup> backups, bool isCreating, bool isRestoring)?
    loaded,
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
    required TResult Function(BackupLoading value) loading,
    required TResult Function(BackupLoaded value) loaded,
    required TResult Function(BackupError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackupLoading value)? loading,
    TResult? Function(BackupLoaded value)? loaded,
    TResult? Function(BackupError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackupLoading value)? loading,
    TResult Function(BackupLoaded value)? loaded,
    TResult Function(BackupError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class BackupError implements BackupState {
  const factory BackupError({required final String message}) =
      _$BackupErrorImpl;

  String get message;

  /// Create a copy of BackupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupErrorImplCopyWith<_$BackupErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
