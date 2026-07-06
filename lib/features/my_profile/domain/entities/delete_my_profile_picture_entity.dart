class DeleteMyProfilePictureEntity {
  final bool success;
  final String title;
  final String defaultPhotoUrl;
  final int statusCode;

  const DeleteMyProfilePictureEntity({
    required this.success,
    required this.title,
    required this.defaultPhotoUrl,
    required this.statusCode,
  });
}