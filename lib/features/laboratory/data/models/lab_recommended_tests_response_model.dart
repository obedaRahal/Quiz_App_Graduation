import 'package:quiz_app_grad/features/laboratory/domain/entities/lab_recommended_tests_response_entity.dart';

class LabRecommendedTestsResponseModel {
  final bool success;
  final String title;
  final LabRecommendedTestsDataModel data;
  final int statusCode;

  const LabRecommendedTestsResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory LabRecommendedTestsResponseModel.fromJson(Map<String, dynamic> json) {
    return LabRecommendedTestsResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      data: LabRecommendedTestsDataModel.fromJson(json['data'] ?? {}),
      statusCode: json['status_code'] ?? 0,
    );
  }

  LabRecommendedTestsResponseEntity toEntity() {
    return LabRecommendedTestsResponseEntity(
      success: success,
      title: title,
      currentTab: data.currentTab,
      featuredTopRatedCount: data.featuredTopRatedCount,
      featuredTopRated: data.featuredTopRated.map((e) => e.toEntity()).toList(),
      itemsCount: data.itemsCount,
      items: data.items.map((e) => e.toEntity()).toList(),
      pagination: data.pagination.toEntity(),
      statusCode: statusCode,
    );
  }
}

class LabRecommendedTestsDataModel {
  final String currentTab;
  final int featuredTopRatedCount;
  final List<LabRecommendedFeaturedTestModel> featuredTopRated;
  final int itemsCount;
  final List<LabRecommendedTestItemModel> items;
  final LabRecommendedTestsPaginationModel pagination;

  const LabRecommendedTestsDataModel({
    required this.currentTab,
    required this.featuredTopRatedCount,
    required this.featuredTopRated,
    required this.itemsCount,
    required this.items,
    required this.pagination,
  });

  factory LabRecommendedTestsDataModel.fromJson(Map<String, dynamic> json) {
    return LabRecommendedTestsDataModel(
      currentTab: json['current_tab'] ?? '',
      featuredTopRatedCount: json['featured_top_rated_count'] ?? 0,
      featuredTopRated: (json['featured_top_rated'] as List? ?? [])
          .map((e) => LabRecommendedFeaturedTestModel.fromJson(e))
          .toList(),
      itemsCount: json['items_count'] ?? 0,
      items: (json['items'] as List? ?? [])
          .map((e) => LabRecommendedTestItemModel.fromJson(e))
          .toList(),
      pagination: LabRecommendedTestsPaginationModel.fromJson(
        json['pagination'] ?? {},
      ),
    );
  }
}

class LabRecommendedFeaturedTestModel {
  final LabRecommendedOwnerModel owner;
  final LabRecommendedTestModel test;
  final LabRecommendationModel recommendation;

  const LabRecommendedFeaturedTestModel({
    required this.owner,
    required this.test,
    required this.recommendation,
  });

  factory LabRecommendedFeaturedTestModel.fromJson(Map<String, dynamic> json) {
    return LabRecommendedFeaturedTestModel(
      owner: LabRecommendedOwnerModel.fromJson(json['owner'] ?? {}),
      test: LabRecommendedTestModel.fromJson(json['test'] ?? {}),
      recommendation: LabRecommendationModel.fromJson(
        json['recommendation'] ?? {},
      ),
    );
  }

  LabRecommendedFeaturedTestEntity toEntity() {
    return LabRecommendedFeaturedTestEntity(
      owner: owner.toEntity(),
      test: test.toEntity(),
      recommendation: recommendation.toEntity(),
    );
  }
}

class LabRecommendedTestItemModel {
  final LabRecommendedTestModel test;
  final LabRecommendationModel recommendation;

  const LabRecommendedTestItemModel({
    required this.test,
    required this.recommendation,
  });

  factory LabRecommendedTestItemModel.fromJson(Map<String, dynamic> json) {
    return LabRecommendedTestItemModel(
      test: LabRecommendedTestModel.fromJson(json['test'] ?? {}),
      recommendation: LabRecommendationModel.fromJson(
        json['recommendation'] ?? {},
      ),
    );
  }

  LabRecommendedTestItemEntity toEntity() {
    return LabRecommendedTestItemEntity(
      test: test.toEntity(),
      recommendation: recommendation.toEntity(),
    );
  }
}

class LabRecommendedOwnerModel {
  final String name;
  final String ownerProfilePicture;
  final bool isVerified;
  final int publishedTestsCount;
  final int followersCount;

  const LabRecommendedOwnerModel({
    required this.name,
    required this.ownerProfilePicture,
    required this.isVerified,
    required this.publishedTestsCount,
    required this.followersCount,
  });

  factory LabRecommendedOwnerModel.fromJson(Map<String, dynamic> json) {
    return LabRecommendedOwnerModel(
      name: json['name'] ?? '',
      ownerProfilePicture: json['owner_profile_picture'] ?? '',
      isVerified: json['is_verified'] ?? false,
      publishedTestsCount: json['published_tests_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
    );
  }

  LabRecommendedOwnerEntity toEntity() {
    return LabRecommendedOwnerEntity(
      name: name,
      ownerProfilePicture: ownerProfilePicture,
      isVerified: isVerified,
      publishedTestsCount: publishedTestsCount,
      followersCount: followersCount,
    );
  }
}

class LabRecommendedTestModel {
  final int id;
  final String title;
  final String description;
  final String difficultyLevel;
  final List<String> interestNames;
  final int questionCount;
  final String publishedAt;
  final String publishedAtHuman;
  final double averageRating;
  final num price;

  const LabRecommendedTestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.interestNames,
    required this.questionCount,
    required this.publishedAt,
    required this.publishedAtHuman,
    required this.averageRating,
    required this.price,
  });

  factory LabRecommendedTestModel.fromJson(Map<String, dynamic> json) {
    return LabRecommendedTestModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      difficultyLevel: json['difficulty_level'] ?? '',
      interestNames: (json['interest_names'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      questionCount: json['question_count'] ?? 0,
      publishedAt: json['published_at'] ?? '',
      publishedAtHuman: json['published_at_human'] ?? '',
      averageRating: double.tryParse(
            (json['average_rating'] ?? 0).toString(),
          ) ??
          0.0,
      price: json['price'] ?? 0,
    );
  }

  LabRecommendedTestEntity toEntity() {
    return LabRecommendedTestEntity(
      id: id,
      title: title,
      description: description,
      difficultyLevel: difficultyLevel,
      interestNames: interestNames,
      questionCount: questionCount,
      publishedAt: publishedAt,
      publishedAtHuman: publishedAtHuman,
      averageRating: averageRating,
      price: price,
    );
  }
}

class LabRecommendationModel {
  final double score;
  final LabRecommendationScoreBreakdownModel scoreBreakdown;
  final String candidateBucket;
  final List<int> matchedInterestIds;
  final int matchedInterestsCount;
  final bool matchedByTargetLevel;

  const LabRecommendationModel({
    required this.score,
    required this.scoreBreakdown,
    required this.candidateBucket,
    required this.matchedInterestIds,
    required this.matchedInterestsCount,
    required this.matchedByTargetLevel,
  });

  factory LabRecommendationModel.fromJson(Map<String, dynamic> json) {
    return LabRecommendationModel(
      score: double.tryParse((json['score'] ?? 0).toString()) ?? 0.0,
      scoreBreakdown: LabRecommendationScoreBreakdownModel.fromJson(
        json['score_breakdown'] ?? {},
      ),
      candidateBucket: json['candidate_bucket'] ?? '',
      matchedInterestIds: (json['matched_interest_ids'] as List? ?? [])
          .map((e) => (e as num).toInt())
          .toList(),
      matchedInterestsCount: json['matched_interests_count'] ?? 0,
      matchedByTargetLevel: json['matched_by_target_level'] ?? false,
    );
  }

  LabRecommendationEntity toEntity() {
    return LabRecommendationEntity(
      score: score,
      scoreBreakdown: scoreBreakdown.toEntity(),
      candidateBucket: candidateBucket,
      matchedInterestIds: matchedInterestIds,
      matchedInterestsCount: matchedInterestsCount,
      matchedByTargetLevel: matchedByTargetLevel,
    );
  }
}

class LabRecommendationScoreBreakdownModel {
  final double interestScore;
  final double targetLevelScore;
  final double participantsScore;
  final double likesScore;
  final double ratingScore;
  final double freshnessScore;
  final double bucketScore;

  const LabRecommendationScoreBreakdownModel({
    required this.interestScore,
    required this.targetLevelScore,
    required this.participantsScore,
    required this.likesScore,
    required this.ratingScore,
    required this.freshnessScore,
    required this.bucketScore,
  });

  factory LabRecommendationScoreBreakdownModel.fromJson(
    Map<String, dynamic> json,
  ) {
    double read(String key) =>
        double.tryParse((json[key] ?? 0).toString()) ?? 0.0;

    return LabRecommendationScoreBreakdownModel(
      interestScore: read('interest_score'),
      targetLevelScore: read('target_level_score'),
      participantsScore: read('participants_score'),
      likesScore: read('likes_score'),
      ratingScore: read('rating_score'),
      freshnessScore: read('freshness_score'),
      bucketScore: read('bucket_score'),
    );
  }

  LabRecommendationScoreBreakdownEntity toEntity() {
    return LabRecommendationScoreBreakdownEntity(
      interestScore: interestScore,
      targetLevelScore: targetLevelScore,
      participantsScore: participantsScore,
      likesScore: likesScore,
      ratingScore: ratingScore,
      freshnessScore: freshnessScore,
      bucketScore: bucketScore,
    );
  }
}

class LabRecommendedTestsPaginationModel {
  final int currentPage;
  final int perPage;
  final bool hasMore;

  const LabRecommendedTestsPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.hasMore,
  });

  factory LabRecommendedTestsPaginationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LabRecommendedTestsPaginationModel(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      hasMore: json['has_more'] ?? false,
    );
  }

  LabRecommendedTestsPaginationEntity toEntity() {
    return LabRecommendedTestsPaginationEntity(
      currentPage: currentPage,
      perPage: perPage,
      hasMore: hasMore,
    );
  }
}