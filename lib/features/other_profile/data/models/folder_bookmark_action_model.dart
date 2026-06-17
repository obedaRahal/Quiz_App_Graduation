import '../../domain/entities/folder_bookmark_action_entity.dart';

class FolderBookmarkActionModel extends FolderBookmarkActionEntity {
  const FolderBookmarkActionModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory FolderBookmarkActionModel.fromJson(Map<String, dynamic> json) {
    return FolderBookmarkActionModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] is int
          ? json['status_code']
          : int.tryParse(json['status_code']?.toString() ?? '') ?? 200,
    );
  }
}