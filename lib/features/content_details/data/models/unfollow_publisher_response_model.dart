import '../../domain/entities/unfollow_publisher_response_entity.dart';

class UnfollowPublisherResponseModel extends UnfollowPublisherResponseEntity {
  const UnfollowPublisherResponseModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory UnfollowPublisherResponseModel.fromJson(Map<String, dynamic> json) {
    return UnfollowPublisherResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }
}