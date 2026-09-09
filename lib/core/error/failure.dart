/// Base failure type for domain/data-layer errors, surfaced to the UI as
/// [message]. Mirrors the sealed `Failure` pattern from `CleanArchitectureDemo`.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

/// Input didn't pass validation (client-side or a 4xx-style rejection).
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// The backend (or, for now, the mock datasource) rejected the request.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// A local/cache datasource failed to read or write.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
