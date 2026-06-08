import 'package:quiz_app_grad/features/test_play_modes/domain/entities/register_test_attempt_interaction_entity.dart';

class RegisterTestAttemptInteractionModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const RegisterTestAttemptInteractionModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory RegisterTestAttemptInteractionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegisterTestAttemptInteractionModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: _asInt(json['status_code']),
    );
  }

  RegisterTestAttemptInteractionEntity toEntity() {
    return RegisterTestAttemptInteractionEntity(
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
