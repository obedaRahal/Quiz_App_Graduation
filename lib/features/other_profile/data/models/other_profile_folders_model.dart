import '../../domain/entities/other_profile_folders_entity.dart';

class OtherProfileFoldersResponseModel
    extends OtherProfileFoldersResponseEntity {
  const OtherProfileFoldersResponseModel({
    required super.success,
    required super.message,
    required List<OtherProfileFolderItemModel> super.data,
    required OtherProfileFoldersMetaModel super.meta,
    required super.statusCode,
  });

  factory OtherProfileFoldersResponseModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileFoldersResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: _asMapList(
        json['data'],
      ).map((item) => OtherProfileFolderItemModel.fromJson(item)).toList(),
      meta: OtherProfileFoldersMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

class OtherProfileFolderItemModel extends OtherProfileFolderItemEntity {
  const OtherProfileFolderItemModel({
    required super.id,
    required super.name,
    required super.testsCount,
    required super.publishedAt,
    required super.scientificInterests,
    required super.colorCode,
    required super.viewerHasBookmarked,
  });

  factory OtherProfileFolderItemModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileFolderItemModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      testsCount: _asInt(json['tests_count']),
      publishedAt: json['published_at']?.toString() ?? '',
      scientificInterests: _asStringList(json['scientific_interests']),
      colorCode: json['color_code']?.toString() ?? '#AAAAAA',
      viewerHasBookmarked: json['viewer_has_bookmarked'] == true,
    );
  }
}


class OtherProfileFoldersMetaModel extends OtherProfileFoldersMetaEntity {
  const OtherProfileFoldersMetaModel({
    required super.perPage,
    super.nextCursor,
    super.prevCursor,
    required super.hasMorePages,
  });

  factory OtherProfileFoldersMetaModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileFoldersMetaModel(
      perPage: _asInt(json['per_page'], fallback: 20),
      nextCursor: _asNullableString(json['next_cursor']),
      prevCursor: _asNullableString(json['prev_cursor']),
      hasMorePages: json['has_more_pages'] == true,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty || text == 'null') return null;

  return text;
}

List<String> _asStringList(dynamic value) {
  if (value is! List) return [];

  return value.map((item) => item.toString()).toList();
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}
