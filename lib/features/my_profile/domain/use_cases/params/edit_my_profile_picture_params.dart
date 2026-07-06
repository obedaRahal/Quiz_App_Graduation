class EditMyProfilePictureParams {
  final int userId;
  final String type; 
  final String imagePath;

  const EditMyProfilePictureParams({
    required this.userId,
    required this.type,
    required this.imagePath,
  });
}