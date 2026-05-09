class LabRecommendedTestsResponseEntity {
  final bool success;
  final String title;
  final String currentTab;
  final int featuredTopRatedCount;
  final List<LabRecommendedFeaturedTestEntity> featuredTopRated;
  final int itemsCount;
  final List<LabRecommendedTestItemEntity> items;
  final LabRecommendedTestsPaginationEntity pagination;
  final int statusCode;

  const LabRecommendedTestsResponseEntity({
    required this.success,
    required this.title,
    required this.currentTab,
    required this.featuredTopRatedCount,
    required this.featuredTopRated,
    required this.itemsCount,
    required this.items,
    required this.pagination,
    required this.statusCode,
  });
}

class LabRecommendedFeaturedTestEntity {
  final LabRecommendedOwnerEntity owner;
  final LabRecommendedTestEntity test;
  final LabRecommendationEntity recommendation;

  const LabRecommendedFeaturedTestEntity({
    required this.owner,
    required this.test,
    required this.recommendation,
  });
}

class LabRecommendedTestItemEntity {
  final LabRecommendedTestEntity test;
  final LabRecommendationEntity recommendation;

  const LabRecommendedTestItemEntity({
    required this.test,
    required this.recommendation,
  });
}

class LabRecommendedOwnerEntity {
  final String name;
  final String ownerProfilePicture;
  final bool isVerified;
  final int publishedTestsCount;
  final int followersCount;

  const LabRecommendedOwnerEntity({
    required this.name,
    required this.ownerProfilePicture,
    required this.isVerified,
    required this.publishedTestsCount,
    required this.followersCount,
  });
}

class LabRecommendedTestEntity {
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

  const LabRecommendedTestEntity({
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
}

class LabRecommendationEntity {
  final double score;
  final LabRecommendationScoreBreakdownEntity scoreBreakdown;
  final String candidateBucket;
  final List<int> matchedInterestIds;
  final int matchedInterestsCount;
  final bool matchedByTargetLevel;

  const LabRecommendationEntity({
    required this.score,
    required this.scoreBreakdown,
    required this.candidateBucket,
    required this.matchedInterestIds,
    required this.matchedInterestsCount,
    required this.matchedByTargetLevel,
  });
}

class LabRecommendationScoreBreakdownEntity {
  final double interestScore;
  final double targetLevelScore;
  final double participantsScore;
  final double likesScore;
  final double ratingScore;
  final double freshnessScore;
  final double bucketScore;

  const LabRecommendationScoreBreakdownEntity({
    required this.interestScore,
    required this.targetLevelScore,
    required this.participantsScore,
    required this.likesScore,
    required this.ratingScore,
    required this.freshnessScore,
    required this.bucketScore,
  });
}

class LabRecommendedTestsPaginationEntity {
  final int currentPage;
  final int perPage;
  final bool hasMore;

  const LabRecommendedTestsPaginationEntity({
    required this.currentPage,
    required this.perPage,
    required this.hasMore,
  });
}