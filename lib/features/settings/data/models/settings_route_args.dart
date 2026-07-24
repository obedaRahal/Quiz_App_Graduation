class SettingsRouteArgs {
  final String name;
  final String email;
  final String? imageUrl;

  const SettingsRouteArgs({
    required this.name,
    required this.email,
    this.imageUrl,
  });
}
