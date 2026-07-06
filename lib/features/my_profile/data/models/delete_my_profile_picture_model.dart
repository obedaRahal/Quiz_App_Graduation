import 'package:quiz_app_grad/features/my_profile/domain/entities/delete_my_profile_picture_entity.dart';

class DeleteMyProfilePictureModel extends DeleteMyProfilePictureEntity {
  const DeleteMyProfilePictureModel({
    required super.success,
    required super.title,
    required super.defaultPhotoUrl,
    required super.statusCode,
  });

  factory DeleteMyProfilePictureModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? {};

    return DeleteMyProfilePictureModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      defaultPhotoUrl: data['default_photo_url']?.toString() ?? '',
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value.trim()) ?? fallback;
  return fallback;
}