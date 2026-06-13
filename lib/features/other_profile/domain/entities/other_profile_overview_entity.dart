class OtherProfileOverviewEntity {
  final bool success;
  final String title;
  final OtherProfileOverviewDataEntity data;
  final int statusCode;

  const OtherProfileOverviewEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  OtherProfileOverviewEntity copyWith({
    bool? success,
    String? title,
    OtherProfileOverviewDataEntity? data,
    int? statusCode,
  }) {
    return OtherProfileOverviewEntity(
      success: success ?? this.success,
      title: title ?? this.title,
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class OtherProfileOverviewDataEntity {
  final OtherProfileHeaderEntity header;
  final OtherProfileBasicInfoEntity basicInfo;
  final OtherProfileReviewsEntity reviews;
  final OtherProfileGeneralStatsEntity generalStatistics;

  const OtherProfileOverviewDataEntity({
    required this.header,
    required this.basicInfo,
    required this.reviews,
    required this.generalStatistics,
  });

  OtherProfileOverviewDataEntity copyWith({
    OtherProfileHeaderEntity? header,
    OtherProfileBasicInfoEntity? basicInfo,
    OtherProfileReviewsEntity? reviews,
    OtherProfileGeneralStatsEntity? generalStatistics,
  }) {
    return OtherProfileOverviewDataEntity(
      header: header ?? this.header,
      basicInfo: basicInfo ?? this.basicInfo,
      reviews: reviews ?? this.reviews,
      generalStatistics: generalStatistics ?? this.generalStatistics,
    );
  }
}

class OtherProfileHeaderEntity {
  final int userId;
  final String name;
  final String avatarUrl;
  final String coverUrl;
  final int followersCount;
  final int followingCount;
  final int publishedTestsCount;
  final bool isAcademicallyVerified;
  final bool viewerIsFollowing;

  const OtherProfileHeaderEntity({
    required this.userId,
    required this.name,
    required this.avatarUrl,
    required this.coverUrl,
    required this.followersCount,
    required this.followingCount,
    required this.publishedTestsCount,
    required this.isAcademicallyVerified,
    required this.viewerIsFollowing,
  });

  OtherProfileHeaderEntity copyWith({
    int? userId,
    String? name,
    String? avatarUrl,
    String? coverUrl,
    int? followersCount,
    int? followingCount,
    int? publishedTestsCount,
    bool? isAcademicallyVerified,
    bool? viewerIsFollowing,
  }) {
    return OtherProfileHeaderEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      publishedTestsCount: publishedTestsCount ?? this.publishedTestsCount,
      isAcademicallyVerified:
          isAcademicallyVerified ?? this.isAcademicallyVerified,
      viewerIsFollowing: viewerIsFollowing ?? this.viewerIsFollowing,
    );
  }
}

class OtherProfileBasicInfoEntity {
  final String educationLevel;
  final String governorate;
  final String gender;
  final String joinedAt;
  final List<String> interests;

  const OtherProfileBasicInfoEntity({
    required this.educationLevel,
    required this.governorate,
    required this.gender,
    required this.joinedAt,
    required this.interests,
  });
}

class OtherProfileReviewsEntity {
  final double averageRating;
  final int totalReviewsCount;
  final List<OtherProfileRatingDistributionEntity> ratingDistribution;

  const OtherProfileReviewsEntity({
    required this.averageRating,
    required this.totalReviewsCount,
    required this.ratingDistribution,
  });
}

class OtherProfileRatingDistributionEntity {
  final int count;
  final int percentage;

  const OtherProfileRatingDistributionEntity({
    required this.count,
    required this.percentage,
  });
}

class OtherProfileGeneralStatsEntity {
  final int testLikesCount;
  final int testCommentsCount;
  final int testBookmarksCount;

  const OtherProfileGeneralStatsEntity({
    required this.testLikesCount,
    required this.testCommentsCount,
    required this.testBookmarksCount,
  });
}
