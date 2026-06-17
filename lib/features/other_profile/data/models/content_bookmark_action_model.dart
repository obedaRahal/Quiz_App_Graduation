import '../../domain/entities/content_bookmark_action_entity.dart';

class ContentBookmarkActionModel extends ContentBookmarkActionEntity {
  const ContentBookmarkActionModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory ContentBookmarkActionModel.fromJson(Map<String, dynamic> json) {
    return ContentBookmarkActionModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] is int
          ? json['status_code']
          : int.tryParse(json['status_code']?.toString() ?? '') ?? 200,
    );
  }
}