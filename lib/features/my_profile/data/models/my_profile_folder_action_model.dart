import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_folder_action_entity.dart';

class MyProfileFolderActionModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const MyProfileFolderActionModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory MyProfileFolderActionModel.fromJson(Map<String, dynamic> json) {
    return MyProfileFolderActionModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: _asInt(json['status_code']),
    );
  }

  MyProfileFolderActionEntity toEntity() {
    return MyProfileFolderActionEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}