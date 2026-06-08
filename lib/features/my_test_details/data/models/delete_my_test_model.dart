import 'package:quiz_app_grad/features/my_test_details/domain/entities/delete_my_test_entity.dart';

class DeleteMyTestModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const DeleteMyTestModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory DeleteMyTestModel.fromJson(Map<String, dynamic> json) {
    return DeleteMyTestModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: _asInt(json['status_code']),
    );
  }

  DeleteMyTestEntity toEntity() {
    return DeleteMyTestEntity(
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
