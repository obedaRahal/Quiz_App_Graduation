import '../../domain/entities/other_profile_content_entity.dart';

class OtherProfileContentResponseModel
    extends OtherProfileContentResponseEntity {
  const OtherProfileContentResponseModel({
    required super.success,
    required super.message,
    required List<OtherProfileContentItemModel> super.data,
    required OtherProfileContentMetaModel super.meta,
    required super.statusCode,
  });

  factory OtherProfileContentResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtherProfileContentResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: _asMapList(json['data'])
          .map((item) => OtherProfileContentItemModel.fromJson(item))
          .toList(),
      meta: OtherProfileContentMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

class OtherProfileContentItemModel extends OtherProfileContentItemEntity {
  const OtherProfileContentItemModel({
    required super.id,
    required super.urlContent,
    required super.title,
    required super.description,
    required super.type,
    required super.interests,
    required super.likeCount,
    required super.publishedAt,
    required super.viewerHasBookmarked,
  });

  factory OtherProfileContentItemModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileContentItemModel(
      id: _asInt(json['id']),
      urlContent: json['url_content']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      interests: _asStringList(json['interests']),
      likeCount: _asInt(json['like_count']),
      publishedAt: json['published_at']?.toString() ?? '',
      viewerHasBookmarked: json['viewer_has_bookmarked'] == true,
    );
  }
}

class OtherProfileContentMetaModel extends OtherProfileContentMetaEntity {
  const OtherProfileContentMetaModel({
    required super.perPage,
    super.nextCursor,
    super.prevCursor,
    required super.hasMorePages,
  });

  factory OtherProfileContentMetaModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileContentMetaModel(
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