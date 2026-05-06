import '../../domain/entities/other_test_details_reviews_entity.dart';

class OtherTestDetailsReviewsModel {
  final bool success;
  final String title;
  final ReviewsDataModel data;
  final int statusCode;

  const OtherTestDetailsReviewsModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory OtherTestDetailsReviewsModel.fromJson(Map<String, dynamic> json) {
    return OtherTestDetailsReviewsModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      data: ReviewsDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  OtherTestDetailsReviewsEntity toEntity() {
    return OtherTestDetailsReviewsEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class ReviewsDataModel {
  final ReviewsSummaryModel summary;
  final TestReviewModel? myReview;
  final List<TestReviewModel> reviews;
  final ReviewsMetaModel meta;

  const ReviewsDataModel({
    required this.summary,
    required this.myReview,
    required this.reviews,
    required this.meta,
  });

  factory ReviewsDataModel.fromJson(Map<String, dynamic> json) {
    final reviewsJson = json['reviews'] as List<dynamic>? ?? [];

    return ReviewsDataModel(
      summary: ReviewsSummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      myReview: _parseMyReview(json['my_review']),
      reviews: reviewsJson
          .map(
            (item) => TestReviewModel.fromJson(
              item as Map<String, dynamic>? ?? {},
            ),
          )
          .toList(),
      meta: ReviewsMetaModel.fromJson(
        json['meta'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  static TestReviewModel? _parseMyReview(dynamic value) {
    if (value == null) return null;

    // الباك أحيانًا يرجع [] بدل null، يا سلام على اتساق الكون.
    if (value is List && value.isEmpty) return null;

    if (value is Map<String, dynamic>) {
      return TestReviewModel.fromJson(
        value,
        userKey: 'my_account_details',
      );
    }

    return null;
  }

  ReviewsDataEntity toEntity() {
    return ReviewsDataEntity(
      summary: summary.toEntity(),
      myReview: myReview?.toEntity(),
      reviews: reviews.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
    );
  }
}

class ReviewsSummaryModel {
  final double averageRating;
  final int totalReviewsCount;
  final int commentsCount;
  final List<RatingDistributionModel> ratingDistribution;

  const ReviewsSummaryModel({
    required this.averageRating,
    required this.totalReviewsCount,
    required this.commentsCount,
    required this.ratingDistribution,
  });

  factory ReviewsSummaryModel.fromJson(Map<String, dynamic> json) {
    final distributionMap =
        json['rating_distribution'] as Map<String, dynamic>? ?? {};

    final distribution = [5, 4, 3, 2, 1].map((stars) {
      final item = distributionMap[stars.toString()] as Map<String, dynamic>?;

      return RatingDistributionModel.fromJson(
        stars: stars,
        json: item ?? {},
      );
    }).toList();

    return ReviewsSummaryModel(
      averageRating:
          double.tryParse(json['average_rating']?.toString() ?? '0') ?? 0,
      totalReviewsCount:
          int.tryParse(json['total_reviews_count']?.toString() ?? '0') ?? 0,
      commentsCount:
          int.tryParse(json['comments_count']?.toString() ?? '0') ?? 0,
      ratingDistribution: distribution,
    );
  }

  ReviewsSummaryEntity toEntity() {
    return ReviewsSummaryEntity(
      averageRating: averageRating,
      totalReviewsCount: totalReviewsCount,
      commentsCount: commentsCount,
      ratingDistribution:
          ratingDistribution.map((item) => item.toEntity()).toList(),
    );
  }
}

class RatingDistributionModel {
  final int stars;
  final int count;
  final double percentage;

  const RatingDistributionModel({
    required this.stars,
    required this.count,
    required this.percentage,
  });

  factory RatingDistributionModel.fromJson({
    required int stars,
    required Map<String, dynamic> json,
  }) {
    return RatingDistributionModel(
      stars: stars,
      count: int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      percentage:
          double.tryParse(json['percentage']?.toString() ?? '0') ?? 0,
    );
  }

  RatingDistributionEntity toEntity() {
    return RatingDistributionEntity(
      stars: stars,
      count: count,
      percentage: percentage,
    );
  }
}

class TestReviewModel {
  final int id;
  final int rating;
  final String reviewText;
  final String createdAt;
  final int yesCount;
  final ReviewUserModel user;
  final ReviewViewerFeedbackModel? viewerFeedback;

  const TestReviewModel({
    required this.id,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.yesCount,
    required this.user,
    required this.viewerFeedback,
  });

  factory TestReviewModel.fromJson(
    Map<String, dynamic> json, {
    String userKey = 'reviewer',
  }) {
    return TestReviewModel(
      id: json['id'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      reviewText: json['review_text']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      yesCount: json['yes_count'] as int? ?? 0,
      user: ReviewUserModel.fromJson(
        json[userKey] as Map<String, dynamic>? ?? {},
      ),
      viewerFeedback: json['viewer_feedback'] == null
          ? null
          : ReviewViewerFeedbackModel.fromJson(
              json['viewer_feedback'] as Map<String, dynamic>? ?? {},
            ),
    );
  }

  TestReviewEntity toEntity() {
    return TestReviewEntity(
      id: id,
      rating: rating,
      reviewText: reviewText,
      createdAt: createdAt,
      yesCount: yesCount,
      user: user.toEntity(),
      viewerFeedback: viewerFeedback?.toEntity(),
    );
  }
}

class ReviewUserModel {
  final int id;
  final String name;
  final String avatarUrl;
  final bool isAcademicallyVerified;

  const ReviewUserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isAcademicallyVerified,
  });

  factory ReviewUserModel.fromJson(Map<String, dynamic> json) {
    return ReviewUserModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      isAcademicallyVerified:
          json['is_academically_verified'] as bool? ?? false,
    );
  }

  ReviewUserEntity toEntity() {
    return ReviewUserEntity(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      isAcademicallyVerified: isAcademicallyVerified,
    );
  }
}

class ReviewViewerFeedbackModel {
  final bool hasVoted;
  final String? vote;

  const ReviewViewerFeedbackModel({
    required this.hasVoted,
    required this.vote,
  });

  factory ReviewViewerFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ReviewViewerFeedbackModel(
      hasVoted: json['has_voted'] as bool? ?? false,
      vote: json['vote']?.toString(),
    );
  }

  ReviewViewerFeedbackEntity toEntity() {
    return ReviewViewerFeedbackEntity(
      hasVoted: hasVoted,
      vote: vote,
    );
  }
}

class ReviewsMetaModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const ReviewsMetaModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });

  factory ReviewsMetaModel.fromJson(Map<String, dynamic> json) {
    return ReviewsMetaModel(
      currentPage: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 1,
      hasMorePages: json['has_more_pages'] as bool? ?? false,
    );
  }

  ReviewsMetaEntity toEntity() {
    return ReviewsMetaEntity(
      currentPage: currentPage,
      perPage: perPage,
      total: total,
      lastPage: lastPage,
      hasMorePages: hasMorePages,
    );
  }
}