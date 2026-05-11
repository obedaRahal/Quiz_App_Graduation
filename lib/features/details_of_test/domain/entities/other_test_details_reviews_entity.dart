class OtherTestDetailsReviewsEntity {
  final bool success;
  final String title;
  final ReviewsDataEntity data;
  final int statusCode;

  const OtherTestDetailsReviewsEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  OtherTestDetailsReviewsEntity copyWith({
  bool? success,
  String? title,
  ReviewsDataEntity? data,
  int? statusCode,
}) {
  return OtherTestDetailsReviewsEntity(
    success: success ?? this.success,
    title: title ?? this.title,
    data: data ?? this.data,
    statusCode: statusCode ?? this.statusCode,
  );
}
}

class ReviewsDataEntity {
  final ReviewsSummaryEntity summary;
  final TestReviewEntity? myReview;
  final List<TestReviewEntity> reviews;
  final ReviewsMetaEntity meta;

  const ReviewsDataEntity({
    required this.summary,
    required this.myReview,
    required this.reviews,
    required this.meta,
  });

  ReviewsDataEntity copyWith({
  ReviewsSummaryEntity? summary,
  TestReviewEntity? myReview,
  List<TestReviewEntity>? reviews,
  ReviewsMetaEntity? meta,
}) {
  return ReviewsDataEntity(
    summary: summary ?? this.summary,
    myReview: myReview ?? this.myReview,
    reviews: reviews ?? this.reviews,
    meta: meta ?? this.meta,
  );
}
}

class ReviewsSummaryEntity {
  final double averageRating;
  final int totalReviewsCount;
  final int commentsCount;
  final List<RatingDistributionEntity> ratingDistribution;

  const ReviewsSummaryEntity({
    required this.averageRating,
    required this.totalReviewsCount,
    required this.commentsCount,
    required this.ratingDistribution,
  });
}

class RatingDistributionEntity {
  final int stars;
  final int count;
  final double percentage;

  const RatingDistributionEntity({
    required this.stars,
    required this.count,
    required this.percentage,
  });
}

class TestReviewEntity {
  final int id;
  final int rating;
  final String reviewText;
  final String createdAt;
  final int yesCount;
  final ReviewUserEntity user;
  final ReviewViewerFeedbackEntity? viewerFeedback;

  const TestReviewEntity({
    required this.id,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.yesCount,
    required this.user,
    required this.viewerFeedback,
  });

  TestReviewEntity copyWith({
  int? id,
  int? rating,
  String? reviewText,
  String? createdAt,
  int? yesCount,
  ReviewUserEntity? user,
  ReviewViewerFeedbackEntity? viewerFeedback,
}) {
  return TestReviewEntity(
    id: id ?? this.id,
    rating: rating ?? this.rating,
    reviewText: reviewText ?? this.reviewText,
    createdAt: createdAt ?? this.createdAt,
    yesCount: yesCount ?? this.yesCount,
    user: user ?? this.user,
    viewerFeedback: viewerFeedback ?? this.viewerFeedback,
  );
}
}

class ReviewUserEntity {
  final int id;
  final String name;
  final String avatarUrl;
  final bool isAcademicallyVerified;

  const ReviewUserEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isAcademicallyVerified,
  });
}

class ReviewViewerFeedbackEntity {
  final bool hasVoted;
  final String? vote;

  const ReviewViewerFeedbackEntity({
    required this.hasVoted,
    required this.vote,
  });
}

class ReviewsMetaEntity {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const ReviewsMetaEntity({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });
}