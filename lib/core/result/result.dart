import 'package:saydaliati/core/errors/failure.dart';

/// The return type of every repository method and use case.
///
/// [Result] is the single, explicit boundary between "something can fail" code
/// (data + domain) and the presentation layer. It is deliberately *not* used to
/// model UI async state — that is Riverpod's [AsyncValue]'s job. A notifier
/// consumes a [Result] and translates it into loading / data / error for the UI.
///
/// It is a plain sealed class (no code generation) so it stays dependency-free
/// and trivially usable in pure Dart tests.
sealed class Result<T> {
  const Result();

  /// Wraps a successful [value].
  const factory Result.success(T value) = Success<T>;

  /// Wraps a [failure].
  const factory Result.failure(Failure failure) = FailureResult<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  /// The value when successful, otherwise `null`.
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        FailureResult<T>() => null,
      };

  /// The failure when failed, otherwise `null`.
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        FailureResult<T>(:final failure) => failure,
      };

  /// Collapses both branches into a single value of type [R].
  R fold<R>(
    R Function(T value) onSuccess,
    R Function(Failure failure) onFailure,
  ) =>
      switch (this) {
        Success<T>(:final value) => onSuccess(value),
        FailureResult<T>(:final failure) => onFailure(failure),
      };

  /// Transforms the success value while preserving a failure.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Success<T>(:final value) => Success<R>(transform(value)),
        FailureResult<T>(:final failure) => FailureResult<R>(failure),
      };
}

/// The success branch of a [Result].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Success<T> && other.value == value);

  @override
  int get hashCode => value.hashCode;
}

/// The failure branch of a [Result].
final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FailureResult<T> && other.failure == failure);

  @override
  int get hashCode => failure.hashCode;
}
