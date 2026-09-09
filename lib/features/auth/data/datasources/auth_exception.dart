/// Thrown by [AuthLocalDataSource]  on a
/// validation/auth rejection. Caught and converted to a [Failure] by the
/// repository implementation.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}
