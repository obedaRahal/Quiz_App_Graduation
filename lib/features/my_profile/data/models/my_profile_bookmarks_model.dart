import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';

class MyProfileBookmarksModel extends MyProfileBookmarksEntity {
  const MyProfileBookmarksModel({
    required super.success,
    required super.title,
    required MyProfileBookmarksDataModel super.data,
    required super.statusCode,
  });

  factory MyProfileBookmarksModel.fromJson(Map<String, dynamic> json) {
    final dataJson = (json['data'] as Map?)?.cast<String, dynamic>() ?? {};

    return MyProfileBookmarksModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: MyProfileBookmarksDataModel.fromJson(dataJson),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

class MyProfileBookmarksDataModel extends MyProfileBookmarksDataEntity {
  const MyProfileBookmarksDataModel({
    required super.tab,
    required List<MyProfileBookmarkItemEntity> super.items,
    required MyProfileBookmarksMetaModel super.meta,
  });

  factory MyProfileBookmarksDataModel.fromJson(Map<String, dynamic> json) {
    final tab = json['tab']?.toString() ?? '';

    final items = _asMapList(json['items']).map((item) {
      if (tab == 'tests') {
        return MyProfileBookmarkTestModel.fromJson(item);
      }

      if (tab == 'materials') {
        return MyProfileBookmarkMaterialModel.fromJson(item);
      }

      if (tab == 'folders') {
        return MyProfileBookmarkFolderModel.fromJson(item);
      }

      return MyProfileBookmarkUnknownModel.fromJson(item);
    }).toList();

    return MyProfileBookmarksDataModel(
      tab: tab,
      items: items,
      meta: MyProfileBookmarksMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }
}

class MyProfileBookmarksMetaModel extends MyProfileBookmarksMetaEntity {
  const MyProfileBookmarksMetaModel({
    required super.perPage,
    super.nextCursor,
    super.previousCursor,
    required super.hasMorePages,
  });

  factory MyProfileBookmarksMetaModel.fromJson(Map<String, dynamic> json) {
    return MyProfileBookmarksMetaModel(
      perPage: _asInt(json['per_page']),
      nextCursor: _asNullableString(json['next_cursor']),
      previousCursor: _asNullableString(
        json['previous_cursor'] ?? json['prev_cursor'],
      ),
      hasMorePages: json['has_more_pages'] == true,
    );
  }
}

class MyProfileBookmarkTestModel extends MyProfileBookmarkTestEntity {
  const MyProfileBookmarkTestModel({
    required super.id,
    required super.title,
    required super.description,
    required super.interests,
    required super.difficultyLevel,
    required super.averageRating,
    required super.price,
    required super.publishedAt,
    required super.questionCount,
  });

  factory MyProfileBookmarkTestModel.fromJson(Map<String, dynamic> json) {
    return MyProfileBookmarkTestModel(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      interests: _asStringList(json['interests']),
      difficultyLevel: json['difficulty_level']?.toString() ?? '',
      averageRating: _asDouble(json['average_rating']),
      price: json['price']?.toString() ?? '0',
      publishedAt: json['published_at']?.toString() ?? '',
      questionCount: _asInt(json['question_count']),
    );
  }
}

class MyProfileBookmarkMaterialModel extends MyProfileBookmarkMaterialEntity {
  const MyProfileBookmarkMaterialModel({
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

  factory MyProfileBookmarkMaterialModel.fromJson(Map<String, dynamic> json) {
    return MyProfileBookmarkMaterialModel(
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

class MyProfileBookmarkFolderModel extends MyProfileBookmarkFolderEntity {
  const MyProfileBookmarkFolderModel({
    required super.id,
    required super.name,
    required super.testsCount,
    required super.publishedAt,
    required super.scientificInterests,
    required super.colorCode,
    required super.viewerHasBookmarked,
  });

  factory MyProfileBookmarkFolderModel.fromJson(Map<String, dynamic> json) {
    return MyProfileBookmarkFolderModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      testsCount: _asInt(json['tests_count']),
      publishedAt: json['published_at']?.toString() ?? '',
      scientificInterests: _asStringList(json['scientific_interests']),
      colorCode: json['color_code']?.toString() ?? '#FFFFFF',
      viewerHasBookmarked: json['viewer_has_bookmarked'] == true,
    );
  }
}

class MyProfileBookmarkUnknownModel extends MyProfileBookmarkItemEntity {
  const MyProfileBookmarkUnknownModel({
    required super.id,
  });

  factory MyProfileBookmarkUnknownModel.fromJson(Map<String, dynamic> json) {
    return MyProfileBookmarkUnknownModel(
      id: _asInt(json['id']),
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

double _asDouble(dynamic value, {double fallback = 0}) {
  if (value is double) return value;
  if (value is int) return value.toDouble();

  if (value is String) {
    final text = value.trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
    return double.tryParse(text) ?? fallback;
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