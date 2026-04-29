import '../../domain/entities/recommended_users_response_entity.dart';

class RecommendedUsersResponseModel {
  final bool success;
  final String title;
  final List<RecommendedUserModel> data;
  final int statusCode;

  const RecommendedUsersResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory RecommendedUsersResponseModel.fromJson(Map<String, dynamic> json) {
    return RecommendedUsersResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => RecommendedUserModel.fromJson(item))
          .toList(),
      statusCode: json['status_code'] ?? 0,
    );
  }

  RecommendedUsersResponseEntity toEntity() {
    return RecommendedUsersResponseEntity(
      success: success,
      title: title,
      users: data.map((item) => item.toEntity()).toList(),
      statusCode: statusCode,
    );
  }
}

class RecommendedUserModel {
  final int id;
  final String name;
  final String avatarUrl;
  final int publishedTestsCount;
  final double averageTestRating;

  const RecommendedUserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.publishedTestsCount,
    required this.averageTestRating,
  });

  factory RecommendedUserModel.fromJson(Map<String, dynamic> json) {
    return RecommendedUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      publishedTestsCount: json['published_tests_count'] ?? 0,
      averageTestRating: (json['average_test_rating'] as num? ?? 0).toDouble(),
    );
  }

  RecommendedUserEntity toEntity() {
    return RecommendedUserEntity(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      publishedTestsCount: publishedTestsCount,
      averageTestRating: averageTestRating,
    );
  }
}