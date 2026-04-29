class RecommendedTestsResponseEntity {
  final bool success;
  final String title;
  final String currentTab;
  final int itemsCount;
  final List<RecommendedTestItemEntity> tests;
  final int statusCode;

  const RecommendedTestsResponseEntity({
    required this.success,
    required this.title,
    required this.currentTab,
    required this.itemsCount,
    required this.tests,
    required this.statusCode,
  });
}

class RecommendedTestItemEntity {
  final TestOwnerEntity owner;
  final RecommendedTestEntity test;
  final TestRecommendationEntity recommendation;

  const RecommendedTestItemEntity({
    required this.owner,
    required this.test,
    required this.recommendation,
  });
}

class TestOwnerEntity {
  final String name;
  final String profilePicture;
  final int publishedTestsCount;
  final int followersCount;
  final bool isVerified;

  const TestOwnerEntity({
    required this.name,
    required this.profilePicture,
    required this.publishedTestsCount,
    required this.followersCount,
    required this.isVerified,
  });
}

class RecommendedTestEntity {
  final int id;
  final String title;
  final String description;
  final List<String> interestNames;
  final String difficultyLevel;
  final int questionCount;
  final double averageRating;
  final num price;

  const RecommendedTestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.interestNames,
    required this.difficultyLevel,
    required this.questionCount,
    required this.averageRating,
    required this.price,
  });
}

class TestRecommendationEntity {
  final double score;
  final RecommendationScoreBreakdownEntity scoreBreakdown;
  final String candidateBucket;
  final List<int> matchedInterestIds;
  final int matchedInterestsCount;
  final bool matchedByTargetLevel;

  const TestRecommendationEntity({
    required this.score,
    required this.scoreBreakdown,
    required this.candidateBucket,
    required this.matchedInterestIds,
    required this.matchedInterestsCount,
    required this.matchedByTargetLevel,
  });
}

class RecommendationScoreBreakdownEntity {
  final double interestScore;
  final double targetLevelScore;
  final double participantsScore;
  final double ratingScore;
  final double freshnessScore;
  final double bucketScore;

  const RecommendationScoreBreakdownEntity({
    required this.interestScore,
    required this.targetLevelScore,
    required this.participantsScore,
    required this.ratingScore,
    required this.freshnessScore,
    required this.bucketScore,
  });
}