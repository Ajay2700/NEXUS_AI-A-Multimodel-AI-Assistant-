// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message, String? errorCode) llm,
    required TResult Function(String message) voice,
    required TResult Function(String message) vision,
    required TResult Function(String message) storage,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message, String? errorCode)? llm,
    TResult? Function(String message)? voice,
    TResult? Function(String message)? vision,
    TResult? Function(String message)? storage,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message, String? errorCode)? llm,
    TResult Function(String message)? voice,
    TResult Function(String message)? vision,
    TResult Function(String message)? storage,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(LLMFailure value) llm,
    required TResult Function(VoiceFailure value) voice,
    required TResult Function(VisionFailure value) vision,
    required TResult Function(StorageFailure value) storage,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(LLMFailure value)? llm,
    TResult? Function(VoiceFailure value)? voice,
    TResult? Function(VisionFailure value)? vision,
    TResult? Function(StorageFailure value)? storage,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(LLMFailure value)? llm,
    TResult Function(VoiceFailure value)? voice,
    TResult Function(VisionFailure value)? vision,
    TResult Function(StorageFailure value)? storage,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? statusCode});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? statusCode = freezed}) {
    return _then(
      _$NetworkFailureImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        statusCode:
            freezed == statusCode
                ? _value.statusCode
                : statusCode // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl({required this.message, this.statusCode});

  @override
  final String message;
  @override
  final int? statusCode;

  @override
  String toString() {
    return 'Failure.network(message: $message, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message, String? errorCode) llm,
    required TResult Function(String message) voice,
    required TResult Function(String message) vision,
    required TResult Function(String message) storage,
  }) {
    return network(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message, String? errorCode)? llm,
    TResult? Function(String message)? voice,
    TResult? Function(String message)? vision,
    TResult? Function(String message)? storage,
  }) {
    return network?.call(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message, String? errorCode)? llm,
    TResult Function(String message)? voice,
    TResult Function(String message)? vision,
    TResult Function(String message)? storage,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message, statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(LLMFailure value) llm,
    required TResult Function(VoiceFailure value) voice,
    required TResult Function(VisionFailure value) vision,
    required TResult Function(StorageFailure value) storage,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(LLMFailure value)? llm,
    TResult? Function(VoiceFailure value)? voice,
    TResult? Function(VisionFailure value)? vision,
    TResult? Function(StorageFailure value)? storage,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(LLMFailure value)? llm,
    TResult Function(VoiceFailure value)? voice,
    TResult Function(VisionFailure value)? vision,
    TResult Function(StorageFailure value)? storage,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure({
    required final String message,
    final int? statusCode,
  }) = _$NetworkFailureImpl;

  @override
  String get message;
  int? get statusCode;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ServerFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ServerFailureImplCopyWith(
    _$ServerFailureImpl value,
    $Res Function(_$ServerFailureImpl) then,
  ) = __$$ServerFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? statusCode});
}

/// @nodoc
class __$$ServerFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ServerFailureImpl>
    implements _$$ServerFailureImplCopyWith<$Res> {
  __$$ServerFailureImplCopyWithImpl(
    _$ServerFailureImpl _value,
    $Res Function(_$ServerFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? statusCode = freezed}) {
    return _then(
      _$ServerFailureImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        statusCode:
            freezed == statusCode
                ? _value.statusCode
                : statusCode // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc

class _$ServerFailureImpl implements ServerFailure {
  const _$ServerFailureImpl({required this.message, this.statusCode});

  @override
  final String message;
  @override
  final int? statusCode;

  @override
  String toString() {
    return 'Failure.server(message: $message, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      __$$ServerFailureImplCopyWithImpl<_$ServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message, String? errorCode) llm,
    required TResult Function(String message) voice,
    required TResult Function(String message) vision,
    required TResult Function(String message) storage,
  }) {
    return server(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message, String? errorCode)? llm,
    TResult? Function(String message)? voice,
    TResult? Function(String message)? vision,
    TResult? Function(String message)? storage,
  }) {
    return server?.call(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message, String? errorCode)? llm,
    TResult Function(String message)? voice,
    TResult Function(String message)? vision,
    TResult Function(String message)? storage,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(message, statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(LLMFailure value) llm,
    required TResult Function(VoiceFailure value) voice,
    required TResult Function(VisionFailure value) vision,
    required TResult Function(StorageFailure value) storage,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(LLMFailure value)? llm,
    TResult? Function(VoiceFailure value)? voice,
    TResult? Function(VisionFailure value)? vision,
    TResult? Function(StorageFailure value)? storage,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(LLMFailure value)? llm,
    TResult Function(VoiceFailure value)? voice,
    TResult Function(VisionFailure value)? vision,
    TResult Function(StorageFailure value)? storage,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class ServerFailure implements Failure {
  const factory ServerFailure({
    required final String message,
    final int? statusCode,
  }) = _$ServerFailureImpl;

  @override
  String get message;
  int? get statusCode;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LLMFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$LLMFailureImplCopyWith(
    _$LLMFailureImpl value,
    $Res Function(_$LLMFailureImpl) then,
  ) = __$$LLMFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? errorCode});
}

/// @nodoc
class __$$LLMFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$LLMFailureImpl>
    implements _$$LLMFailureImplCopyWith<$Res> {
  __$$LLMFailureImplCopyWithImpl(
    _$LLMFailureImpl _value,
    $Res Function(_$LLMFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? errorCode = freezed}) {
    return _then(
      _$LLMFailureImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        errorCode:
            freezed == errorCode
                ? _value.errorCode
                : errorCode // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$LLMFailureImpl implements LLMFailure {
  const _$LLMFailureImpl({required this.message, this.errorCode});

  @override
  final String message;
  @override
  final String? errorCode;

  @override
  String toString() {
    return 'Failure.llm(message: $message, errorCode: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LLMFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, errorCode);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LLMFailureImplCopyWith<_$LLMFailureImpl> get copyWith =>
      __$$LLMFailureImplCopyWithImpl<_$LLMFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message, String? errorCode) llm,
    required TResult Function(String message) voice,
    required TResult Function(String message) vision,
    required TResult Function(String message) storage,
  }) {
    return llm(message, errorCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message, String? errorCode)? llm,
    TResult? Function(String message)? voice,
    TResult? Function(String message)? vision,
    TResult? Function(String message)? storage,
  }) {
    return llm?.call(message, errorCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message, String? errorCode)? llm,
    TResult Function(String message)? voice,
    TResult Function(String message)? vision,
    TResult Function(String message)? storage,
    required TResult orElse(),
  }) {
    if (llm != null) {
      return llm(message, errorCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(LLMFailure value) llm,
    required TResult Function(VoiceFailure value) voice,
    required TResult Function(VisionFailure value) vision,
    required TResult Function(StorageFailure value) storage,
  }) {
    return llm(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(LLMFailure value)? llm,
    TResult? Function(VoiceFailure value)? voice,
    TResult? Function(VisionFailure value)? vision,
    TResult? Function(StorageFailure value)? storage,
  }) {
    return llm?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(LLMFailure value)? llm,
    TResult Function(VoiceFailure value)? voice,
    TResult Function(VisionFailure value)? vision,
    TResult Function(StorageFailure value)? storage,
    required TResult orElse(),
  }) {
    if (llm != null) {
      return llm(this);
    }
    return orElse();
  }
}

abstract class LLMFailure implements Failure {
  const factory LLMFailure({
    required final String message,
    final String? errorCode,
  }) = _$LLMFailureImpl;

  @override
  String get message;
  String? get errorCode;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LLMFailureImplCopyWith<_$LLMFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VoiceFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$VoiceFailureImplCopyWith(
    _$VoiceFailureImpl value,
    $Res Function(_$VoiceFailureImpl) then,
  ) = __$$VoiceFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$VoiceFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$VoiceFailureImpl>
    implements _$$VoiceFailureImplCopyWith<$Res> {
  __$$VoiceFailureImplCopyWithImpl(
    _$VoiceFailureImpl _value,
    $Res Function(_$VoiceFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$VoiceFailureImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$VoiceFailureImpl implements VoiceFailure {
  const _$VoiceFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.voice(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoiceFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoiceFailureImplCopyWith<_$VoiceFailureImpl> get copyWith =>
      __$$VoiceFailureImplCopyWithImpl<_$VoiceFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message, String? errorCode) llm,
    required TResult Function(String message) voice,
    required TResult Function(String message) vision,
    required TResult Function(String message) storage,
  }) {
    return voice(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message, String? errorCode)? llm,
    TResult? Function(String message)? voice,
    TResult? Function(String message)? vision,
    TResult? Function(String message)? storage,
  }) {
    return voice?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message, String? errorCode)? llm,
    TResult Function(String message)? voice,
    TResult Function(String message)? vision,
    TResult Function(String message)? storage,
    required TResult orElse(),
  }) {
    if (voice != null) {
      return voice(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(LLMFailure value) llm,
    required TResult Function(VoiceFailure value) voice,
    required TResult Function(VisionFailure value) vision,
    required TResult Function(StorageFailure value) storage,
  }) {
    return voice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(LLMFailure value)? llm,
    TResult? Function(VoiceFailure value)? voice,
    TResult? Function(VisionFailure value)? vision,
    TResult? Function(StorageFailure value)? storage,
  }) {
    return voice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(LLMFailure value)? llm,
    TResult Function(VoiceFailure value)? voice,
    TResult Function(VisionFailure value)? vision,
    TResult Function(StorageFailure value)? storage,
    required TResult orElse(),
  }) {
    if (voice != null) {
      return voice(this);
    }
    return orElse();
  }
}

abstract class VoiceFailure implements Failure {
  const factory VoiceFailure({required final String message}) =
      _$VoiceFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoiceFailureImplCopyWith<_$VoiceFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VisionFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$VisionFailureImplCopyWith(
    _$VisionFailureImpl value,
    $Res Function(_$VisionFailureImpl) then,
  ) = __$$VisionFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$VisionFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$VisionFailureImpl>
    implements _$$VisionFailureImplCopyWith<$Res> {
  __$$VisionFailureImplCopyWithImpl(
    _$VisionFailureImpl _value,
    $Res Function(_$VisionFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$VisionFailureImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$VisionFailureImpl implements VisionFailure {
  const _$VisionFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.vision(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisionFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VisionFailureImplCopyWith<_$VisionFailureImpl> get copyWith =>
      __$$VisionFailureImplCopyWithImpl<_$VisionFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message, String? errorCode) llm,
    required TResult Function(String message) voice,
    required TResult Function(String message) vision,
    required TResult Function(String message) storage,
  }) {
    return vision(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message, String? errorCode)? llm,
    TResult? Function(String message)? voice,
    TResult? Function(String message)? vision,
    TResult? Function(String message)? storage,
  }) {
    return vision?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message, String? errorCode)? llm,
    TResult Function(String message)? voice,
    TResult Function(String message)? vision,
    TResult Function(String message)? storage,
    required TResult orElse(),
  }) {
    if (vision != null) {
      return vision(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(LLMFailure value) llm,
    required TResult Function(VoiceFailure value) voice,
    required TResult Function(VisionFailure value) vision,
    required TResult Function(StorageFailure value) storage,
  }) {
    return vision(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(LLMFailure value)? llm,
    TResult? Function(VoiceFailure value)? voice,
    TResult? Function(VisionFailure value)? vision,
    TResult? Function(StorageFailure value)? storage,
  }) {
    return vision?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(LLMFailure value)? llm,
    TResult Function(VoiceFailure value)? voice,
    TResult Function(VisionFailure value)? vision,
    TResult Function(StorageFailure value)? storage,
    required TResult orElse(),
  }) {
    if (vision != null) {
      return vision(this);
    }
    return orElse();
  }
}

abstract class VisionFailure implements Failure {
  const factory VisionFailure({required final String message}) =
      _$VisionFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VisionFailureImplCopyWith<_$VisionFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$StorageFailureImplCopyWith(
    _$StorageFailureImpl value,
    $Res Function(_$StorageFailureImpl) then,
  ) = __$$StorageFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StorageFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$StorageFailureImpl>
    implements _$$StorageFailureImplCopyWith<$Res> {
  __$$StorageFailureImplCopyWithImpl(
    _$StorageFailureImpl _value,
    $Res Function(_$StorageFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$StorageFailureImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$StorageFailureImpl implements StorageFailure {
  const _$StorageFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.storage(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      __$$StorageFailureImplCopyWithImpl<_$StorageFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message, String? errorCode) llm,
    required TResult Function(String message) voice,
    required TResult Function(String message) vision,
    required TResult Function(String message) storage,
  }) {
    return storage(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message, String? errorCode)? llm,
    TResult? Function(String message)? voice,
    TResult? Function(String message)? vision,
    TResult? Function(String message)? storage,
  }) {
    return storage?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message, String? errorCode)? llm,
    TResult Function(String message)? voice,
    TResult Function(String message)? vision,
    TResult Function(String message)? storage,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(LLMFailure value) llm,
    required TResult Function(VoiceFailure value) voice,
    required TResult Function(VisionFailure value) vision,
    required TResult Function(StorageFailure value) storage,
  }) {
    return storage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(LLMFailure value)? llm,
    TResult? Function(VoiceFailure value)? voice,
    TResult? Function(VisionFailure value)? vision,
    TResult? Function(StorageFailure value)? storage,
  }) {
    return storage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(LLMFailure value)? llm,
    TResult Function(VoiceFailure value)? voice,
    TResult Function(VisionFailure value)? vision,
    TResult Function(StorageFailure value)? storage,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(this);
    }
    return orElse();
  }
}

abstract class StorageFailure implements Failure {
  const factory StorageFailure({required final String message}) =
      _$StorageFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
