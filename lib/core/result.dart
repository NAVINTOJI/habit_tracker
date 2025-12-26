/// Result type for error handling
/// Represents either a success value or an error
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;
  const Failure(this.message, [this.exception]);
}

/// Extension methods for Result
extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get valueOrNull => this is Success<T> ? (this as Success<T>).value : null;
  String? get errorOrNull => this is Failure<T> ? (this as Failure<T>).message : null;
  
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(String message) onFailure,
  }) {
    return switch (this) {
      Success(value: final v) => onSuccess(v),
      Failure(message: final m) => onFailure(m),
    };
  }
}
