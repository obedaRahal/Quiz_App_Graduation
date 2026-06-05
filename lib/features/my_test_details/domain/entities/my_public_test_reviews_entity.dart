class MyPublicTestReviewsEntity {
  final bool success;
  final String title;
  final MyPublicTestReviewsDataEntity data;
  final int statusCode;

  const MyPublicTestReviewsEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  MyPublicTestReviewsEntity copyWith({
    bool? success,
    String? title,
    MyPublicTestReviewsDataEntity? data,
    int? statusCode,
  }) {
    return MyPublicTestReviewsEntity(
      success: success ?? this.success,
      title: title ?? this.title,
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class MyPublicTestReviewsDataEntity {
  final MyPublicTestReviewsSummaryEntity summary;
  final List<MyPublicTestReviewEntity> reviews;
  final MyPublicTestReviewsMetaEntity meta;

  const MyPublicTestReviewsDataEntity({
    required this.summary,
    required this.reviews,
    required this.meta,
  });

  MyPublicTestReviewsDataEntity copyWith({
    MyPublicTestReviewsSummaryEntity? summary,
    List<MyPublicTestReviewEntity>? reviews,
    MyPublicTestReviewsMetaEntity? meta,
  }) {
    return MyPublicTestReviewsDataEntity(
      summary: summary ?? this.summary,
      reviews: reviews ?? this.reviews,
      meta: meta ?? this.meta,
    );
  }
}

class MyPublicTestReviewsSummaryEntity {
  final double averageRating;
  final int totalReviewsCount;
  final int commentsCount;
  final List<MyPublicTestRatingDistributionEntity> ratingDistribution;

  const MyPublicTestReviewsSummaryEntity({
    required this.averageRating,
    required this.totalReviewsCount,
    required this.commentsCount,
    required this.ratingDistribution,
  });
}

class MyPublicTestRatingDistributionEntity {
  final int stars;
  final int count;
  final double percentage;

  const MyPublicTestRatingDistributionEntity({
    required this.stars,
    required this.count,
    required this.percentage,
  });
}

class MyPublicTestReviewEntity {
  final int id;
  final int rating;
  final String reviewText;
  final String createdAt;
  final int yesCount;
  final MyPublicTestReviewUserEntity reviewer;
  final MyPublicTestReviewViewerFeedbackEntity? viewerFeedback;

  const MyPublicTestReviewEntity({
    required this.id,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.yesCount,
    required this.reviewer,
    required this.viewerFeedback,
  });

  MyPublicTestReviewEntity copyWith({
    int? id,
    int? rating,
    String? reviewText,
    String? createdAt,
    int? yesCount,
    MyPublicTestReviewUserEntity? reviewer,
    MyPublicTestReviewViewerFeedbackEntity? viewerFeedback,
  }) {
    return MyPublicTestReviewEntity(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      createdAt: createdAt ?? this.createdAt,
      yesCount: yesCount ?? this.yesCount,
      reviewer: reviewer ?? this.reviewer,
      viewerFeedback: viewerFeedback ?? this.viewerFeedback,
    );
  }
}

class MyPublicTestReviewUserEntity {
  final int id;
  final String name;
  final String avatarUrl;
  final bool isAcademicallyVerified;

  const MyPublicTestReviewUserEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isAcademicallyVerified,
  });
}

class MyPublicTestReviewViewerFeedbackEntity {
  final bool hasVoted;
  final String? vote;

  const MyPublicTestReviewViewerFeedbackEntity({
    required this.hasVoted,
    required this.vote,
  });
}

class MyPublicTestReviewsMetaEntity {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const MyPublicTestReviewsMetaEntity({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });
}