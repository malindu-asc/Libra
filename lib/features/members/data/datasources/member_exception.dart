/// Thrown by [MemberLocalDataSource] on a rejected profile/password change.
/// Caught and converted to a [Failure] by the repository implementation.
class MemberException implements Exception {
  const MemberException(this.message);

  final String message;
}