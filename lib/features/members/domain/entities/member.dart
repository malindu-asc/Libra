/// The member's own editable profile — exactly the six fields in the backend's
/// Member schema, nothing added. Deliberately a different class from `auth`'s
/// `AuthenticatedMember` (which only carries what a login response returns):
/// different meaning, different lifecycle, different source endpoint.
class Member {
  const Member({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.registeredDate,
    required this.isActive,
  });

  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime registeredDate;
  final bool isActive;
}
