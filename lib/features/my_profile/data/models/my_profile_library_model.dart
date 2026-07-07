// lib/features/my_profile/data/models/my_profile_library_model.dart

import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';

class MyProfileLibraryModel extends MyProfileLibraryEntity {
  const MyProfileLibraryModel({
    required super.success,
    required super.message,
    required List<MyProfileLibraryItemModel> super.data,
    required MyProfileLibraryMetaModel super.meta,
    required super.statusCode,
  });

  factory MyProfileLibraryModel.fromJson(Map<String, dynamic> json) {
    return MyProfileLibraryModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? json['title']?.toString() ?? '',
      data: _asMapList(
        json['data'],
      ).map((item) => MyProfileLibraryItemModel.fromJson(item)).toList(),
      meta: MyProfileLibraryMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

class MyProfileLibraryItemModel extends MyProfileLibraryItemEntity {
  const MyProfileLibraryItemModel({
    required super.id,
    required super.urlContent,
    required super.title,
    required super.description,
    required super.type,
    required super.libraryMaterialKind,
    required super.interests,
    required super.likeCount,
    required super.publishedAt,
    required super.viewerHasBookmarked,
  });

  factory MyProfileLibraryItemModel.fromJson(Map<String, dynamic> json) {
    return MyProfileLibraryItemModel(
      id: _asInt(json['id']),
      urlContent: json['url_content']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      libraryMaterialKind: json['library_material_kind']?.toString() ?? '',
      interests: _asStringList(json['interests']),
      likeCount: _asInt(json['like_count']),
      publishedAt: json['published_at']?.toString() ?? '',
      viewerHasBookmarked: json['viewer_has_bookmarked'] == true,
    );
  }
}

class MyProfileLibraryMetaModel extends MyProfileLibraryMetaEntity {
  const MyProfileLibraryMetaModel({
    required super.perPage,
    super.nextCursor,
    super.prevCursor,
    required super.hasMorePages,
  });

  factory MyProfileLibraryMetaModel.fromJson(Map<String, dynamic> json) {
    return MyProfileLibraryMetaModel(
      perPage: _asInt(json['per_page']),
      nextCursor: _asNullableString(json['next_cursor']),
      prevCursor: _asNullableString(
        json['prev_cursor'] ?? json['previous_cursor'],
      ),
      hasMorePages: json['has_more_pages'] == true,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();

  if (value is String) {
    final text = value.trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
    return int.tryParse(text) ?? fallback;
  }

  return fallback;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;

  return text;
}

List<String> _asStringList(dynamic value) {
  if (value is! List) return [];

  return value
      .map((item) => item?.toString() ?? '')
      .where((item) => item.trim().isNotEmpty)
      .toList();
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}
