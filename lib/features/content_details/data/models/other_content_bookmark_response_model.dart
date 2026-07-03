import '../../domain/entities/other_content_bookmark_response_entity.dart';

class OtherContentBookmarkResponseModel
    extends OtherContentBookmarkResponseEntity {
  const OtherContentBookmarkResponseModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory OtherContentBookmarkResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtherContentBookmarkResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }
}