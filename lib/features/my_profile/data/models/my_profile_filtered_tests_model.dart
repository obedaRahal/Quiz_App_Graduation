import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_filtered_tests_entity.dart';

class MyProfileFilteredTestsModel
    extends MyProfileFilteredTestsEntity {
  const MyProfileFilteredTestsModel({
    required super.success,
    required super.message,
    required super.data,
    required super.meta,
    required super.statusCode,
  });

  factory MyProfileFilteredTestsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    final items = rawData is List
        ? rawData
              .whereType<Map<String, dynamic>>()
              .map(MyProfileFilteredTestItemModel.fromJson)
              .toList()
        : <MyProfileFilteredTestItemModel>[];

    final rawMeta = json['meta'];

    return MyProfileFilteredTestsModel(
      success: json['success'] == true,
      message:
          json['message']?.toString() ??
          json['title']?.toString() ??
          '',
      data: items,
      meta: rawMeta is Map<String, dynamic>
          ? MyProfileFilteredTestsMetaModel.fromJson(rawMeta)
          : const MyProfileFilteredTestsMetaModel(
              perPage: 0,
              nextCursor: null,
              prevCursor: null,
              hasMorePages: false,
            ),
      statusCode:
          _parseInt(json['status_code']) ?? 0,
    );
  }

  MyProfileFilteredTestsEntity toEntity() {
    return MyProfileFilteredTestsEntity(
      success: success,
      message: message,
      data: data,
      meta: meta,
      statusCode: statusCode,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}

class MyProfileFilteredTestItemModel
    extends MyProfileFilteredTestItemEntity {
  const MyProfileFilteredTestItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.difficultyLevel,
    required super.price,
    required super.averageRating,
    required super.publishedAt,
    required super.questionCount,
    required super.interests,
  });

  factory MyProfileFilteredTestItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawInterests = json['interests'];

    return MyProfileFilteredTestItemModel(
      id: _parseInt(json['id']) ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      difficultyLevel:
          json['difficulty_level']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      averageRating:
          _parseDouble(json['average_rating']) ?? 0,
      publishedAt:
          json['published_at']?.toString() ?? '',
      questionCount:
          _parseInt(json['question_count']) ?? 0,
      interests: rawInterests is List
          ? rawInterests
                .map((item) => item.toString())
                .toList()
          : const [],
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}

class MyProfileFilteredTestsMetaModel
    extends MyProfileFilteredTestsMetaEntity {
  const MyProfileFilteredTestsMetaModel({
    required super.perPage,
    required super.nextCursor,
    required super.prevCursor,
    required super.hasMorePages,
  });

  factory MyProfileFilteredTestsMetaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyProfileFilteredTestsMetaModel(
      perPage: _parseInt(json['per_page']) ?? 0,
      nextCursor: json['next_cursor']?.toString(),
      prevCursor: json['prev_cursor']?.toString(),
      hasMorePages: json['has_more_pages'] == true,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}