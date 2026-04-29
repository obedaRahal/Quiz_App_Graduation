import '../../domain/entities/recommended_tests_response_entity.dart';

class RecommendedTestsResponseModel {
  final bool success;
  final String title;
  final RecommendedTestsDataModel data;
  final int statusCode;

  const RecommendedTestsResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory RecommendedTestsResponseModel.fromJson(Map<String, dynamic> json) {
    return RecommendedTestsResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      data: RecommendedTestsDataModel.fromJson(json['data'] ?? {}),
      statusCode: json['status_code'] ?? 0,
    );
  }

  RecommendedTestsResponseEntity toEntity() {
    return RecommendedTestsResponseEntity(
      success: success,
      title: title,
      currentTab: data.currentTab,
      itemsCount: data.itemsCount,
      tests: data.tests.map((item) => item.toEntity()).toList(),
      statusCode: statusCode,
    );
  }
}

class RecommendedTestsDataModel {
  final String currentTab;
  final int itemsCount;
  final List<RecommendedTestItemModel> tests;

  const RecommendedTestsDataModel({
    required this.currentTab,
    required this.itemsCount,
    required this.tests,
  });

  factory RecommendedTestsDataModel.fromJson(Map<String, dynamic> json) {
    return RecommendedTestsDataModel(
      currentTab: json['current_tab'] ?? '',
      itemsCount: json['items_count'] ?? 0,
      tests: (json['tests'] as List? ?? [])
          .map((item) => RecommendedTestItemModel.fromJson(item))
          .toList(),
    );
  }
}

class RecommendedTestItemModel {
  final TestOwnerModel owner;
  final RecommendedTestModel test;
  final TestRecommendationModel recommendation;

  const RecommendedTestItemModel({
    required this.owner,
    required this.test,
    required this.recommendation,
  });

  factory RecommendedTestItemModel.fromJson(Map<String, dynamic> json) {
    return RecommendedTestItemModel(
      owner: TestOwnerModel.fromJson(json['owner'] ?? {}),
      test: RecommendedTestModel.fromJson(json['test'] ?? {}),
      recommendation: TestRecommendationModel.fromJson(
        json['recommendation'] ?? {},
      ),
    );
  }

  RecommendedTestItemEntity toEntity() {
    return RecommendedTestItemEntity(
      owner: owner.toEntity(),
      test: test.toEntity(),
      recommendation: recommendation.toEntity(),
    );
  }
}

class TestOwnerModel {
  final String name;
  final String profilePicture;
  final int publishedTestsCount;
  final int followersCount;
  final bool isVerified;

  const TestOwnerModel({
    required this.name,
    required this.profilePicture,
    required this.publishedTestsCount,
    required this.followersCount,
    required this.isVerified,
  });

  factory TestOwnerModel.fromJson(Map<String, dynamic> json) {
    return TestOwnerModel(
      name: json['name'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      publishedTestsCount: json['published_tests_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      isVerified: json['is_verified'] ?? false,
    );
  }

  TestOwnerEntity toEntity() {
    return TestOwnerEntity(
      name: name,
      profilePicture: profilePicture,
      publishedTestsCount: publishedTestsCount,
      followersCount: followersCount,
      isVerified: isVerified,
    );
  }
}

class RecommendedTestModel {
  final int id;
  final String title;
  final String description;
  final List<String> interestNames;
  final String difficultyLevel;
  final int questionCount;
  final double averageRating;
  final num price;

  const RecommendedTestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.interestNames,
    required this.difficultyLevel,
    required this.questionCount,
    required this.averageRating,
    required this.price,
  });

  factory RecommendedTestModel.fromJson(Map<String, dynamic> json) {
    return RecommendedTestModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      interestNames: (json['interest_names'] as List? ?? [])
          .map((item) => item.toString())
          .toList(),
      difficultyLevel: json['difficulty_level'] ?? '',
      questionCount: json['question_count'] ?? 0,
      averageRating: (json['average_rating'] as num? ?? 0).toDouble(),
      price: json['price'] ?? 0,
    );
  }

  RecommendedTestEntity toEntity() {
    return RecommendedTestEntity(
      id: id,
      title: title,
      description: description,
      interestNames: interestNames,
      difficultyLevel: difficultyLevel,
      questionCount: questionCount,
      averageRating: averageRating,
      price: price,
    );
  }
}

class TestRecommendationModel {
  final double score;
  final RecommendationScoreBreakdownModel scoreBreakdown;
  final String candidateBucket;
  final List<int> matchedInterestIds;
  final int matchedInterestsCount;
  final bool matchedByTargetLevel;

  const TestRecommendationModel({
    required this.score,
    required this.scoreBreakdown,
    required this.candidateBucket,
    required this.matchedInterestIds,
    required this.matchedInterestsCount,
    required this.matchedByTargetLevel,
  });

  factory TestRecommendationModel.fromJson(Map<String, dynamic> json) {
    return TestRecommendationModel(
      score: (json['score'] as num? ?? 0).toDouble(),
      scoreBreakdown: RecommendationScoreBreakdownModel.fromJson(
        json['score_breakdown'] ?? {},
      ),
      candidateBucket: json['candidate_bucket'] ?? '',
      matchedInterestIds: (json['matched_interest_ids'] as List? ?? [])
          .map((item) => (item as num).toInt())
          .toList(),
      matchedInterestsCount: json['matched_interests_count'] ?? 0,
      matchedByTargetLevel: json['matched_by_target_level'] ?? false,
    );
  }

  TestRecommendationEntity toEntity() {
    return TestRecommendationEntity(
      score: score,
      scoreBreakdown: scoreBreakdown.toEntity(),
      candidateBucket: candidateBucket,
      matchedInterestIds: matchedInterestIds,
      matchedInterestsCount: matchedInterestsCount,
      matchedByTargetLevel: matchedByTargetLevel,
    );
  }
}

class RecommendationScoreBreakdownModel {
  final double interestScore;
  final double targetLevelScore;
  final double participantsScore;
  final double ratingScore;
  final double freshnessScore;
  final double bucketScore;

  const RecommendationScoreBreakdownModel({
    required this.interestScore,
    required this.targetLevelScore,
    required this.participantsScore,
    required this.ratingScore,
    required this.freshnessScore,
    required this.bucketScore,
  });

  factory RecommendationScoreBreakdownModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecommendationScoreBreakdownModel(
      interestScore: (json['interest_score'] as num? ?? 0).toDouble(),
      targetLevelScore: (json['target_level_score'] as num? ?? 0).toDouble(),
      participantsScore: (json['participants_score'] as num? ?? 0).toDouble(),
      ratingScore: (json['rating_score'] as num? ?? 0).toDouble(),
      freshnessScore: (json['freshness_score'] as num? ?? 0).toDouble(),
      bucketScore: (json['bucket_score'] as num? ?? 0).toDouble(),
    );
  }

  RecommendationScoreBreakdownEntity toEntity() {
    return RecommendationScoreBreakdownEntity(
      interestScore: interestScore,
      targetLevelScore: targetLevelScore,
      participantsScore: participantsScore,
      ratingScore: ratingScore,
      freshnessScore: freshnessScore,
      bucketScore: bucketScore,
    );
  }
}