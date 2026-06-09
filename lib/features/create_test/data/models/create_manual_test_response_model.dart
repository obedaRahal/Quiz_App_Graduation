import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_response_entity.dart';

class CreateManualTestResponseModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const CreateManualTestResponseModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory CreateManualTestResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateManualTestResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] is int
          ? json['status_code']
          : int.tryParse(json['status_code']?.toString() ?? '') ?? 0,
    );
  }

  CreateManualTestResponseEntity toEntity() {
    return CreateManualTestResponseEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}