import 'package:quiz_app_grad/features/laboratory/domain/entities/filter_tests_response_entity.dart';

class FilterTestsResponseModel {
  final bool success;
  final String message;
  final List<FilteredTestModel> data;
  final FilterTestsMetaModel meta;
  final int statusCode;

  const FilterTestsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });

  factory FilterTestsResponseModel.fromJson(Map<String, dynamic> json) {
    return FilterTestsResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) {
            if (item is Map<String, dynamic>) {
              return FilteredTestModel.fromJson(item);
            }

            return FilteredTestModel.fromJson(const {});
          })
          .toList(),
      meta: json['meta'] is Map<String, dynamic>
          ? FilterTestsMetaModel.fromJson(json['meta'])
          : FilterTestsMetaModel.fromJson(const {}),
      statusCode: int.tryParse((json['status_code'] ?? 0).toString()) ?? 0,
    );
  }

  FilterTestsResponseEntity toEntity() {
    return FilterTestsResponseEntity(
      success: success,
      message: message,
      tests: data.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
      statusCode: statusCode,
    );
  }
}

class FilteredTestModel {
  final int id;
  final String title;
  final String description;
  final String difficultyLevel;
  final String price;
  final String averageRating;
  final String publishedAt;
  final int questionCount;
  final List<String> interests;

  const FilteredTestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.price,
    required this.averageRating,
    required this.publishedAt,
    required this.questionCount,
    required this.interests,
  });

  factory FilteredTestModel.fromJson(Map<String, dynamic> json) {
    return FilteredTestModel(
      id: int.tryParse((json['id'] ?? 0).toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      difficultyLevel: json['difficulty_level']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      averageRating: json['average_rating']?.toString() ?? '',
      publishedAt: json['published_at']?.toString() ?? '',
      questionCount: int.tryParse((json['question_count'] ?? 0).toString()) ?? 0,
      interests: (json['interests'] as List? ?? [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  FilteredTestEntity toEntity() {
    return FilteredTestEntity(
      id: id,
      title: title,
      description: description,
      difficultyLevel: difficultyLevel,
      price: price,
      averageRating: averageRating,
      publishedAt: publishedAt,
      questionCount: questionCount,
      interests: interests,
    );
  }
}

class FilterTestsMetaModel {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const FilterTestsMetaModel({
    required this.perPage,
    required this.nextCursor,
    required this.prevCursor,
    required this.hasMorePages,
  });

  factory FilterTestsMetaModel.fromJson(Map<String, dynamic> json) {
    return FilterTestsMetaModel(
      perPage: int.tryParse((json['per_page'] ?? 0).toString()) ?? 0,
      nextCursor: json['next_cursor']?.toString(),
      prevCursor: json['prev_cursor']?.toString(),
      hasMorePages: json['has_more_pages'] == true,
    );
  }

  FilterTestsMetaEntity toEntity() {
    return FilterTestsMetaEntity(
      perPage: perPage,
      nextCursor: nextCursor,
      prevCursor: prevCursor,
      hasMorePages: hasMorePages,
    );
  }
}