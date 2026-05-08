import 'package:quiz_app_grad/features/laboratory/domain/entities/search_tests_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/search_tests_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';
class SearchTestsByInterestResponseModel {
  final bool success;
  final String message;
  final List<SearchTestByInterestModel> data;
  final SearchTestsByInterestMetaModel meta;
  final int statusCode;

  const SearchTestsByInterestResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });

  factory SearchTestsByInterestResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SearchTestsByInterestResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => SearchTestByInterestModel.fromJson(item))
          .toList(),
      meta: SearchTestsByInterestMetaModel.fromJson(json['meta'] ?? {}),
      statusCode: json['status_code'] ?? 0,
    );
  }

  SearchTestsByInterestResponseEntity toEntity() {
    return SearchTestsByInterestResponseEntity(
      success: success,
      message: message,
      tests: data.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
      statusCode: statusCode,
    );
  }
}

class SearchTestByInterestModel {
  final int id;
  final String title;
  final String description;
  final List<SearchTestInterestModel> interests;
  final String publishedAt;
  final num price;
  final String difficultyLevel;
  final double averageRating;
  final int questionCount;

  const SearchTestByInterestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.publishedAt,
    required this.price,
    required this.difficultyLevel,
    required this.averageRating,
    required this.questionCount,
  });

  factory SearchTestByInterestModel.fromJson(Map<String, dynamic> json) {
    return SearchTestByInterestModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      interests: (json['interests'] as List? ?? [])
          .map((item) => SearchTestInterestModel.fromJson(item))
          .toList(),
      publishedAt: json['published_at'] ?? '',
      price: json['price'] ?? 0,
      difficultyLevel: json['difficulty_level'] ?? '',
      averageRating: double.tryParse(
            (json['average_rating'] ?? 0).toString(),
          ) ??
          0.0,
      questionCount: json['question_count'] ?? 0,
    );
  }

TestByInterestEntity toEntity() {
  return TestByInterestEntity(
    id: id,
    title: title,
    description: description,
    interests: interests.map((item) => item.toEntity()).toList(),
    questionCount: questionCount,
    difficultyLevel: difficultyLevel,
    price: price,
    averageRating: averageRating,
    publishedAgo: publishedAt,
  );
}
}

class SearchTestInterestModel {
  final int id;
  final String name;

  const SearchTestInterestModel({
    required this.id,
    required this.name,
  });

  factory SearchTestInterestModel.fromJson(Map<String, dynamic> json) {
    return SearchTestInterestModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  TestInterestEntity toEntity() {
  return TestInterestEntity(
    id: id,
    name: name,
  );
}
}

class SearchTestsByInterestMetaModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const SearchTestsByInterestMetaModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });

  factory SearchTestsByInterestMetaModel.fromJson(Map<String, dynamic> json) {
    return SearchTestsByInterestMetaModel(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      hasMorePages: json['has_more_pages'] ?? false,
    );
  }

  SearchTestsByInterestMetaEntity toEntity() {
    return SearchTestsByInterestMetaEntity(
      currentPage: currentPage,
      perPage: perPage,
      total: total,
      lastPage: lastPage,
      hasMorePages: hasMorePages,
    );
  }
}