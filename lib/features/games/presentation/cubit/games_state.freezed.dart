// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'games_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GamesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GamesLoading value) loading,
    required TResult Function(GamesLoaded value) loaded,
    required TResult Function(GamesError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GamesLoading value)? loading,
    TResult? Function(GamesLoaded value)? loaded,
    TResult? Function(GamesError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GamesLoading value)? loading,
    TResult Function(GamesLoaded value)? loaded,
    TResult Function(GamesError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamesStateCopyWith<$Res> {
  factory $GamesStateCopyWith(
    GamesState value,
    $Res Function(GamesState) then,
  ) = _$GamesStateCopyWithImpl<$Res, GamesState>;
}

/// @nodoc
class _$GamesStateCopyWithImpl<$Res, $Val extends GamesState>
    implements $GamesStateCopyWith<$Res> {
  _$GamesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GamesLoadingImplCopyWith<$Res> {
  factory _$$GamesLoadingImplCopyWith(
    _$GamesLoadingImpl value,
    $Res Function(_$GamesLoadingImpl) then,
  ) = __$$GamesLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GamesLoadingImplCopyWithImpl<$Res>
    extends _$GamesStateCopyWithImpl<$Res, _$GamesLoadingImpl>
    implements _$$GamesLoadingImplCopyWith<$Res> {
  __$$GamesLoadingImplCopyWithImpl(
    _$GamesLoadingImpl _value,
    $Res Function(_$GamesLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GamesLoadingImpl implements GamesLoading {
  const _$GamesLoadingImpl();

  @override
  String toString() {
    return 'GamesState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GamesLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
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
    TResult? Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )?
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
    required TResult Function(GamesLoading value) loading,
    required TResult Function(GamesLoaded value) loaded,
    required TResult Function(GamesError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GamesLoading value)? loading,
    TResult? Function(GamesLoaded value)? loaded,
    TResult? Function(GamesError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GamesLoading value)? loading,
    TResult Function(GamesLoaded value)? loaded,
    TResult Function(GamesError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class GamesLoading implements GamesState {
  const factory GamesLoading() = _$GamesLoadingImpl;
}

/// @nodoc
abstract class _$$GamesLoadedImplCopyWith<$Res> {
  factory _$$GamesLoadedImplCopyWith(
    _$GamesLoadedImpl value,
    $Res Function(_$GamesLoadedImpl) then,
  ) = __$$GamesLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<Game> games,
    List<Game> filteredGames,
    String searchQuery,
    bool isApplying,
  });
}

/// @nodoc
class __$$GamesLoadedImplCopyWithImpl<$Res>
    extends _$GamesStateCopyWithImpl<$Res, _$GamesLoadedImpl>
    implements _$$GamesLoadedImplCopyWith<$Res> {
  __$$GamesLoadedImplCopyWithImpl(
    _$GamesLoadedImpl _value,
    $Res Function(_$GamesLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
    Object? filteredGames = null,
    Object? searchQuery = null,
    Object? isApplying = null,
  }) {
    return _then(
      _$GamesLoadedImpl(
        games: null == games
            ? _value._games
            : games // ignore: cast_nullable_to_non_nullable
                  as List<Game>,
        filteredGames: null == filteredGames
            ? _value._filteredGames
            : filteredGames // ignore: cast_nullable_to_non_nullable
                  as List<Game>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        isApplying: null == isApplying
            ? _value.isApplying
            : isApplying // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GamesLoadedImpl implements GamesLoaded {
  const _$GamesLoadedImpl({
    required final List<Game> games,
    required final List<Game> filteredGames,
    this.searchQuery = '',
    this.isApplying = false,
  }) : _games = games,
       _filteredGames = filteredGames;

  final List<Game> _games;
  @override
  List<Game> get games {
    if (_games is EqualUnmodifiableListView) return _games;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_games);
  }

  final List<Game> _filteredGames;
  @override
  List<Game> get filteredGames {
    if (_filteredGames is EqualUnmodifiableListView) return _filteredGames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredGames);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool isApplying;

  @override
  String toString() {
    return 'GamesState.loaded(games: $games, filteredGames: $filteredGames, searchQuery: $searchQuery, isApplying: $isApplying)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamesLoadedImpl &&
            const DeepCollectionEquality().equals(other._games, _games) &&
            const DeepCollectionEquality().equals(
              other._filteredGames,
              _filteredGames,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.isApplying, isApplying) ||
                other.isApplying == isApplying));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_games),
    const DeepCollectionEquality().hash(_filteredGames),
    searchQuery,
    isApplying,
  );

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamesLoadedImplCopyWith<_$GamesLoadedImpl> get copyWith =>
      __$$GamesLoadedImplCopyWithImpl<_$GamesLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(games, filteredGames, searchQuery, isApplying);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(games, filteredGames, searchQuery, isApplying);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(games, filteredGames, searchQuery, isApplying);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GamesLoading value) loading,
    required TResult Function(GamesLoaded value) loaded,
    required TResult Function(GamesError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GamesLoading value)? loading,
    TResult? Function(GamesLoaded value)? loaded,
    TResult? Function(GamesError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GamesLoading value)? loading,
    TResult Function(GamesLoaded value)? loaded,
    TResult Function(GamesError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class GamesLoaded implements GamesState {
  const factory GamesLoaded({
    required final List<Game> games,
    required final List<Game> filteredGames,
    final String searchQuery,
    final bool isApplying,
  }) = _$GamesLoadedImpl;

  List<Game> get games;
  List<Game> get filteredGames;
  String get searchQuery;
  bool get isApplying;

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamesLoadedImplCopyWith<_$GamesLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GamesErrorImplCopyWith<$Res> {
  factory _$$GamesErrorImplCopyWith(
    _$GamesErrorImpl value,
    $Res Function(_$GamesErrorImpl) then,
  ) = __$$GamesErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$GamesErrorImplCopyWithImpl<$Res>
    extends _$GamesStateCopyWithImpl<$Res, _$GamesErrorImpl>
    implements _$$GamesErrorImplCopyWith<$Res> {
  __$$GamesErrorImplCopyWithImpl(
    _$GamesErrorImpl _value,
    $Res Function(_$GamesErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$GamesErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GamesErrorImpl implements GamesError {
  const _$GamesErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'GamesState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamesErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamesErrorImplCopyWith<_$GamesErrorImpl> get copyWith =>
      __$$GamesErrorImplCopyWithImpl<_$GamesErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
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
    TResult? Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
      List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      bool isApplying,
    )?
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
    required TResult Function(GamesLoading value) loading,
    required TResult Function(GamesLoaded value) loaded,
    required TResult Function(GamesError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GamesLoading value)? loading,
    TResult? Function(GamesLoaded value)? loaded,
    TResult? Function(GamesError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GamesLoading value)? loading,
    TResult Function(GamesLoaded value)? loaded,
    TResult Function(GamesError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class GamesError implements GamesState {
  const factory GamesError({required final String message}) = _$GamesErrorImpl;

  String get message;

  /// Create a copy of GamesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamesErrorImplCopyWith<_$GamesErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
