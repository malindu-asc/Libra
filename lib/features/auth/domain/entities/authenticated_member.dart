/// `auth`'s own minimal view of a member — just enough to identify who
/// logged in. Deliberately not the same class as any future `members`
/// feature's full profile entity: different meaning, different lifecycle,
/// different purpose (see ARCHITECTURE.md decisions log).
class AuthenticatedMember {
  const AuthenticatedMember({
    required this.id,
    required this.fullName,
    required this.email,
  });

  final String id;
  final String fullName;
  final String email;
}
