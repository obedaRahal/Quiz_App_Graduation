import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folders_entity.dart';

class MyProfileFoldersModel {
  final bool success;
  final String message;
  final List<MyProfileFolderItemModel> data;
  final MyProfileFoldersMetaModel meta;
  final int statusCode;

  const MyProfileFoldersModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });

  factory MyProfileFoldersModel.fromJson(Map<String, dynamic> json) {
    return MyProfileFoldersModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: _asMapList(json['data'])
          .map((item) => MyProfileFolderItemModel.fromJson(item))
          .toList(),
      meta: MyProfileFoldersMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code']),
    );
  }

  MyProfileFoldersEntity toEntity() {
    return MyProfileFoldersEntity(
      success: success,
      message: message,
      data: data.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
      statusCode: statusCode,
    );
  }
}

class MyProfileFolderItemModel {
  final int id;
  final String name;
  final int testsCount;
  final String publishedAt;
  final List<String> scientificInterests;
  final String colorCode;
  final String folderKind;

  const MyProfileFolderItemModel({
    required this.id,
    required this.name,
    required this.testsCount,
    required this.publishedAt,
    required this.scientificInterests,
    required this.colorCode,
    required this.folderKind,
  });

  factory MyProfileFolderItemModel.fromJson(Map<String, dynamic> json) {
    return MyProfileFolderItemModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      testsCount: _asInt(json['tests_count']),
      publishedAt: json['published_at']?.toString() ?? '',
      scientificInterests: _asDynamicList(json['scientific_interests'])
          .map((item) => item.toString())
          .toList(),
      colorCode: json['color_code']?.toString() ?? '#AAAAAA',
      folderKind: json['folder_kind']?.toString() ?? '',
    );
  }

  MyProfileFolderItemEntity toEntity() {
    return MyProfileFolderItemEntity(
      id: id,
      name: name,
      testsCount: testsCount,
      publishedAt: publishedAt,
      scientificInterests: scientificInterests,
      colorCode: colorCode,
      folderKind: folderKind,
    );
  }
}

class MyProfileFoldersMetaModel {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const MyProfileFoldersMetaModel({
    required this.perPage,
    required this.nextCursor,
    required this.prevCursor,
    required this.hasMorePages,
  });

  factory MyProfileFoldersMetaModel.fromJson(Map<String, dynamic> json) {
    return MyProfileFoldersMetaModel(
      perPage: _asInt(json['per_page']),
      nextCursor: _asNullableString(json['next_cursor']),
      prevCursor: _asNullableString(json['prev_cursor']),
      hasMorePages: json['has_more_pages'] == true,
    );
  }

  MyProfileFoldersMetaEntity toEntity() {
    return MyProfileFoldersMetaEntity(
      perPage: perPage,
      nextCursor: nextCursor,
      prevCursor: prevCursor,
      hasMorePages: hasMorePages,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();
  if (text.isEmpty || text == 'null') return null;

  return text;
}

List<dynamic> _asDynamicList(dynamic value) {
  if (value is List) return value;
  return [];
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}