import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';

class TestsByInterestResponseModel {
  final bool success;
  final String message;
  final List<TestByInterestModel> data;
  final TestsByInterestMetaModel meta;
  final int statusCode;

  const TestsByInterestResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });

  factory TestsByInterestResponseModel.fromJson(Map<String, dynamic> json) {
    return TestsByInterestResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => TestByInterestModel.fromJson(item))
          .toList(),
      meta: TestsByInterestMetaModel.fromJson(json['meta'] ?? {}),
      statusCode: json['status_code'] ?? 0,
    );
  }

  TestsByInterestResponseEntity toEntity() {
    return TestsByInterestResponseEntity(
      success: success,
      message: message,
      tests: data.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
      statusCode: statusCode,
    );
  }
}

class TestByInterestModel {
  final int id;
  final String title;
  final String description;
  final List<TestInterestModel> interests;
  final int questionCount;
  final String difficultyLevel;
  final num price;
  final double averageRating;
  final String publishedAgo;

  const TestByInterestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.questionCount,
    required this.difficultyLevel,
    required this.price,
    required this.averageRating,
    required this.publishedAgo,
  });

  factory TestByInterestModel.fromJson(Map<String, dynamic> json) {
    return TestByInterestModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      interests: (json['interests'] as List? ?? [])
          .map((item) => TestInterestModel.fromJson(item))
          .toList(),
      questionCount: json['question_count'] ?? 0,
      difficultyLevel: json['difficulty_level'] ?? '',
      price: json['price'] ?? 0,
      averageRating:
          double.tryParse(
            (json['average_rating'] ?? json['rating'] ?? 0).toString(),
          ) ??
          0.0,
      publishedAgo: json['published_ago'] ?? '',
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
      publishedAgo: publishedAgo,
    );
  }
}

class TestInterestModel {
  final int id;
  final String name;

  const TestInterestModel({required this.id, required this.name});

  factory TestInterestModel.fromJson(Map<String, dynamic> json) {
    return TestInterestModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  TestInterestEntity toEntity() {
    return TestInterestEntity(id: id, name: name);
  }
}

class TestsByInterestMetaModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const TestsByInterestMetaModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });

  factory TestsByInterestMetaModel.fromJson(Map<String, dynamic> json) {
    return TestsByInterestMetaModel(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      hasMorePages: json['has_more_pages'] ?? false,
    );
  }

  TestsByInterestMetaEntity toEntity() {
    return TestsByInterestMetaEntity(
      currentPage: currentPage,
      perPage: perPage,
      total: total,
      lastPage: lastPage,
      hasMorePages: hasMorePages,
    );
  }
}
