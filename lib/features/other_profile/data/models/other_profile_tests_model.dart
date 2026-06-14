import '../../domain/entities/other_profile_tests_entity.dart';

class OtherProfileTestsResponseModel extends OtherProfileTestsResponseEntity {
  const OtherProfileTestsResponseModel({
    required super.success,
    required super.message,
    required List<OtherProfileTestItemModel> super.data,
    required OtherProfileTestsMetaModel super.meta,
    required super.statusCode,
  });

  factory OtherProfileTestsResponseModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileTestsResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: _asMapList(json['data'])
          .map((item) => OtherProfileTestItemModel.fromJson(item))
          .toList(),
      meta: OtherProfileTestsMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

class OtherProfileTestItemModel extends OtherProfileTestItemEntity {
  const OtherProfileTestItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.interests,
    required super.targetLevel,
    required super.difficultyLevel,
    required super.averageRating,
    required super.price,
    required super.publishedAt,
    required super.questionCount,
  });

  factory OtherProfileTestItemModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileTestItemModel(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      interests: _asStringList(json['interests']),
      targetLevel: json['target_level']?.toString() ?? '',
      difficultyLevel: json['difficulty_level']?.toString() ?? '',
      averageRating: _asDouble(json['average_rating']),
      price: json['price']?.toString() ?? '0.00',
      publishedAt: json['published_at']?.toString() ?? '',
      questionCount: _asInt(json['question_count']),
    );
  }
}

class OtherProfileTestsMetaModel extends OtherProfileTestsMetaEntity {
  const OtherProfileTestsMetaModel({
    required super.perPage,
    super.nextCursor,
    super.prevCursor,
    required super.hasMorePages,
  });

  factory OtherProfileTestsMetaModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileTestsMetaModel(
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

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
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