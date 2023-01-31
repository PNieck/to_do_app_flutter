class AppUser {
  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.photo,
  });
}
