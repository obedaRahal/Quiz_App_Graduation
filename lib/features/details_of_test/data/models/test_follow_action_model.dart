import '../../domain/entities/test_follow_action_entity.dart';

class TestFollowActionModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const TestFollowActionModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory TestFollowActionModel.fromJson(Map<String, dynamic> json) {
    return TestFollowActionModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  TestFollowActionEntity toEntity() {
    return TestFollowActionEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}