class OtherTestDetailsOverviewEntity {
  final bool success;
  final String title;
  final int statusCode;
  final TestDetailsOverviewDataEntity data;

  const OtherTestDetailsOverviewEntity({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.data,
  });
}

class TestDetailsOverviewDataEntity {
  final int id;
  final TestBasicInfoEntity basicInfo;
  final TestCreatorEntity creator;
  final TestExtraInfoEntity extraInfo;

  const TestDetailsOverviewDataEntity({
    required this.id,
    required this.basicInfo,
    required this.creator,
    required this.extraInfo,
  });
}

class TestBasicInfoEntity {
  final String title;
  final String description;
  final String difficultyLevel;
  final double price;
  final int likesCount;
  final int reviewsCount;
  final int bookmarksCount;

  const TestBasicInfoEntity({
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.price,
    required this.likesCount,
    required this.reviewsCount,
    required this.bookmarksCount,
  });
}

class TestCreatorEntity {
  final int id;
  final String name;
  final bool isAcademicallyVerified;
  final int followersCount;
  final int followingCount;
  final int publishedTestsCount;
  final String profilePicture;

  const TestCreatorEntity({
    required this.id,
    required this.name,
    required this.isAcademicallyVerified,
    required this.followersCount,
    required this.followingCount,
    required this.publishedTestsCount,
    required this.profilePicture,
  });
}

class TestExtraInfoEntity {
  final int questionCount;
  final int? durationSeconds;
  final int? passMarkPercentage;
  final String publishedAt;
  final String lastContentUpdatedAt;
  final String targetLevel;
  final String language;
  final int participantsCount;
  final String reviewStatus;
  final List<TestInterestEntity> interests;
  final TestViewerContextEntity viewerContext;

  const TestExtraInfoEntity({
    required this.questionCount,
    required this.durationSeconds,
    required this.passMarkPercentage,
    required this.publishedAt,
    required this.lastContentUpdatedAt,
    required this.targetLevel,
    required this.language,
    required this.participantsCount,
    required this.reviewStatus,
    required this.interests,
    required this.viewerContext,
  });
}

class TestInterestEntity {
  final int id;
  final String name;

  const TestInterestEntity({
    required this.id,
    required this.name,
  });
}

class TestViewerContextEntity {
  final bool isOwner;
  final bool isFree;
  final bool isPaid;
  final bool hasPurchased;
  final bool isFollowingCreator;
  final bool canPurchase;
  final bool canDownload;
  final bool canReport;

  const TestViewerContextEntity({
    required this.isOwner,
    required this.isFree,
    required this.isPaid,
    required this.hasPurchased,
    required this.isFollowingCreator,
    required this.canPurchase,
    required this.canDownload,
    required this.canReport,
  });
}