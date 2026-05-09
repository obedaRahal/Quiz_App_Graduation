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

  OtherTestDetailsOverviewEntity copyWith({
    bool? success,
    String? title,
    int? statusCode,
    TestDetailsOverviewDataEntity? data,
  }) {
    return OtherTestDetailsOverviewEntity(
      success: success ?? this.success,
      title: title ?? this.title,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }
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

  TestDetailsOverviewDataEntity copyWith({
    int? id,
    TestBasicInfoEntity? basicInfo,
    TestCreatorEntity? creator,
    TestExtraInfoEntity? extraInfo,
  }) {
    return TestDetailsOverviewDataEntity(
      id: id ?? this.id,
      basicInfo: basicInfo ?? this.basicInfo,
      creator: creator ?? this.creator,
      extraInfo: extraInfo ?? this.extraInfo,
    );
  }
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

  TestBasicInfoEntity copyWith({
    String? title,
    String? description,
    String? difficultyLevel,
    double? price,
    int? likesCount,
    int? reviewsCount,
    int? bookmarksCount,
  }) {
    return TestBasicInfoEntity(
      title: title ?? this.title,
      description: description ?? this.description,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      price: price ?? this.price,
      likesCount: likesCount ?? this.likesCount,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
    );
  }
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

  TestCreatorEntity copyWith({
    int? id,
    String? name,
    bool? isAcademicallyVerified,
    int? followersCount,
    int? followingCount,
    int? publishedTestsCount,
    String? profilePicture,
  }) {
    return TestCreatorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isAcademicallyVerified:
          isAcademicallyVerified ?? this.isAcademicallyVerified,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      publishedTestsCount: publishedTestsCount ?? this.publishedTestsCount,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
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

  TestExtraInfoEntity copyWith({
    int? questionCount,
    int? durationSeconds,
    int? passMarkPercentage,
    String? publishedAt,
    String? lastContentUpdatedAt,
    String? targetLevel,
    String? language,
    int? participantsCount,
    String? reviewStatus,
    List<TestInterestEntity>? interests,
    TestViewerContextEntity? viewerContext,
  }) {
    return TestExtraInfoEntity(
      questionCount: questionCount ?? this.questionCount,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      passMarkPercentage: passMarkPercentage ?? this.passMarkPercentage,
      publishedAt: publishedAt ?? this.publishedAt,
      lastContentUpdatedAt: lastContentUpdatedAt ?? this.lastContentUpdatedAt,
      targetLevel: targetLevel ?? this.targetLevel,
      language: language ?? this.language,
      participantsCount: participantsCount ?? this.participantsCount,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      interests: interests ?? this.interests,
      viewerContext: viewerContext ?? this.viewerContext,
    );
  }
}

class TestInterestEntity {
  final int id;
  final String name;

  const TestInterestEntity({required this.id, required this.name});
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
  final bool hasLiked;
  final bool hasBookmarked;

  const TestViewerContextEntity({
    required this.isOwner,
    required this.isFree,
    required this.isPaid,
    required this.hasPurchased,
    required this.isFollowingCreator,
    required this.canPurchase,
    required this.canDownload,
    required this.canReport,
    required this.hasLiked,
    required this.hasBookmarked,
  });

  TestViewerContextEntity copyWith({
    bool? isOwner,
    bool? isFree,
    bool? isPaid,
    bool? hasPurchased,
    bool? isFollowingCreator,
    bool? canPurchase,
    bool? canDownload,
    bool? canReport,
    bool? hasLiked,
    bool? hasBookmarked,
  }) {
    return TestViewerContextEntity(
      isOwner: isOwner ?? this.isOwner,
      isFree: isFree ?? this.isFree,
      isPaid: isPaid ?? this.isPaid,
      hasPurchased: hasPurchased ?? this.hasPurchased,
      isFollowingCreator: isFollowingCreator ?? this.isFollowingCreator,
      canPurchase: canPurchase ?? this.canPurchase,
      canDownload: canDownload ?? this.canDownload,
      canReport: canReport ?? this.canReport,
      hasLiked: hasLiked ?? this.hasLiked,
      hasBookmarked: hasBookmarked ?? this.hasBookmarked,
    );
  }
}
