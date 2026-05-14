import 'package:quiz_app_grad/features/tests_by_interest/domain/entities/tests_by_interest_response_entity.dart';

class TestsByInterestResponseModel {
  final List<TestByInterestModel> tests;
  final TestsByInterestMetaModel meta;

  const TestsByInterestResponseModel({
    required this.tests,
    required this.meta,
  });

  factory TestsByInterestResponseModel.fromJson(Map<String, dynamic> json) {
    return TestsByInterestResponseModel(
      tests: (json['data'] as List? ?? [])
          .map((item) => TestByInterestModel.fromJson(item))
          .toList(),
      meta: TestsByInterestMetaModel.fromJson(json['meta'] ?? {}),
    );
  }

  TestsByInterestResponseEntity toEntity() {
    return TestsByInterestResponseEntity(
      tests: tests.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
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
    id: int.tryParse(json['id'].toString()) ?? 0,
    title: json['title']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    interests: (json['interests'] as List? ?? [])
        .map((item) => TestInterestModel.fromJson(item))
        .toList(),
    questionCount: int.tryParse(json['question_count'].toString()) ?? 0,
    difficultyLevel: json['difficulty_level']?.toString() ?? '',
    price: num.tryParse(json['price'].toString()) ?? 0,
    averageRating: double.tryParse(json['average_rating'].toString()) ?? 0.0,
    publishedAgo: json['published_ago']?.toString() ?? '',
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

  const TestInterestModel({
    required this.id,
    required this.name,
  });

 factory TestInterestModel.fromJson(Map<String, dynamic> json) {
  return TestInterestModel(
    id: int.tryParse(json['id'].toString()) ?? 0,
    name: json['name']?.toString() ?? '',
  );
}
  TestInterestEntity toEntity() {
    return TestInterestEntity(
      id: id,
      name: name,
    );
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
    currentPage: int.tryParse(json['current_page'].toString()) ?? 1,
    perPage: int.tryParse(json['per_page'].toString()) ?? 10,
    total: int.tryParse(json['total'].toString()) ?? 0,
    lastPage: int.tryParse(json['last_page'].toString()) ?? 1,
    hasMorePages: json['has_more_pages'] == true,
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