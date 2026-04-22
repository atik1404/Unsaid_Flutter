import 'package:common/src/result/failure.dart';

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

  bool get isSuccess => this is SuccessResult<S, F>;
  bool get isFailure => this is FailureResult<S, F>;

  S? get dataOrNull {
    return switch (this) {
      SuccessResult<S, F>(data: final d) => d,
      FailureResult<S, F>() => null,
    };
  }

  F? get failureOrNull {
    return switch (this) {
      SuccessResult<S, F>() => null,
      FailureResult<S, F>(failure: final f) => f,
    };
  }
}

class SuccessResult<S, F extends Failure> extends Result<S, F> {
  final S data;
  const SuccessResult(this.data);
}

class FailureResult<S, F extends Failure> extends Result<S, F> {
  final F failure;
  const FailureResult(this.failure);
}
