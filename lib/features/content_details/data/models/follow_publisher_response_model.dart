import '../../domain/entities/follow_publisher_response_entity.dart';

class FollowPublisherResponseModel extends FollowPublisherResponseEntity {
  const FollowPublisherResponseModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory FollowPublisherResponseModel.fromJson(Map<String, dynamic> json) {
    return FollowPublisherResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }
}