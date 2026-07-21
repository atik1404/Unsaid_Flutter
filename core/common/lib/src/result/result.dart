import 'package:common/common.dart';

sealed class Result<S, F extends Failure> {
  const Result();

  R when<R>({
    required R Function(S data) success,
    required R Function(F failure) failure,
  }) {
    return switch (this) {
      SuccessResult<S, F>(data: final d) => success(d),
      FailureResult<S, F>(failure: final f) => failure(f),
    };
  }

  /// Transform success value, pass through failure
  Result<R, F> map<R>(R Function(S data) transform) {
    return switch (this) {
      SuccessResult<S, F>(data: final d) => SuccessResult(transform(d)),
      FailureResult<S, F>(failure: final f) => FailureResult(f),
    };
  }

  /// Chain dependent async calls
  Future<Result<R, F>> flatMap<R>(
    Future<Result<R, F>> Function(S data) transform,
  ) async {
    return switch (this) {
      SuccessResult<S, F>(data: final d) => transform(d),
      FailureResult<S, F>(failure: final f) => FailureResult(f),
    };
  }

  bool get isSuccess => this is SuccessResult<S, F>;
  bool get isFailure => this is FailureResult<S, F>;

  S? get dataOrNull => switch (this) {
    SuccessResult<S, F>(data: final d) => d,
    FailureResult<S, F>() => null,
  };

  F? get failureOrNull => switch (this) {
    SuccessResult<S, F>() => null,
    FailureResult<S, F>(failure: final f) => f,
  };
}

final class SuccessResult<S, F extends Failure> extends Result<S, F> {
  final S data;
  const SuccessResult(this.data);
}

final class FailureResult<S, F extends Failure> extends Result<S, F> {
  final F failure;
  const FailureResult(this.failure);
}
