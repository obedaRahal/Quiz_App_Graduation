import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_personal_info_entity.dart';

class EditMyProfilePersonalInfoModel extends EditMyProfilePersonalInfoEntity {
  const EditMyProfilePersonalInfoModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory EditMyProfilePersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return EditMyProfilePersonalInfoModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();

  if (value is String) {
    return int.tryParse(value.trim()) ?? fallback;
  }

  return fallback;
}