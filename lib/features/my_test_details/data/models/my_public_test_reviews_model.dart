import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_reviews_entity.dart';

class MyPublicTestReviewsModel {
  final bool success;
  final String title;
  final MyPublicTestReviewsDataModel data;
  final int statusCode;

  const MyPublicTestReviewsModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory MyPublicTestReviewsModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestReviewsModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: MyPublicTestReviewsDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code']),
    );
  }

  MyPublicTestReviewsEntity toEntity() {
    return MyPublicTestReviewsEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class MyPublicTestReviewsDataModel {
  final MyPublicTestReviewsSummaryModel summary;
  final List<MyPublicTestReviewModel> reviews;
  final MyPublicTestReviewsMetaModel meta;

  const MyPublicTestReviewsDataModel({
    required this.summary,
    required this.reviews,
    required this.meta,
  });

  factory MyPublicTestReviewsDataModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestReviewsDataModel(
      summary: MyPublicTestReviewsSummaryModel.fromJson(
        (json['summary'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      reviews: _asList(json['reviews'])
          .map((item) => MyPublicTestReviewModel.fromJson(item))
          .toList(),
      meta: MyPublicTestReviewsMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  MyPublicTestReviewsDataEntity toEntity() {
    return MyPublicTestReviewsDataEntity(
      summary: summary.toEntity(),
      reviews: reviews.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
    );
  }
}

class MyPublicTestReviewsSummaryModel {
  final double averageRating;
  final int totalReviewsCount;
  final int commentsCount;
  final List<MyPublicTestRatingDistributionModel> ratingDistribution;

  const MyPublicTestReviewsSummaryModel({
    required this.averageRating,
    required this.totalReviewsCount,
    required this.commentsCount,
    required this.ratingDistribution,
  });

  factory MyPublicTestReviewsSummaryModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestReviewsSummaryModel(
      averageRating: _asDouble(json['average_rating']),
      totalReviewsCount: _asInt(json['total_reviews_count']),
      commentsCount: _asInt(json['comments_count']),
      ratingDistribution: _parseRatingDistribution(
        json['rating_distribution'],
      ),
    );
  }

  MyPublicTestReviewsSummaryEntity toEntity() {
    return MyPublicTestReviewsSummaryEntity(
      averageRating: averageRating,
      totalReviewsCount: totalReviewsCount,
      commentsCount: commentsCount,
      ratingDistribution:
          ratingDistribution.map((item) => item.toEntity()).toList(),
    );
  }
}

class MyPublicTestRatingDistributionModel {
  final int stars;
  final int count;
  final double percentage;

  const MyPublicTestRatingDistributionModel({
    required this.stars,
    required this.count,
    required this.percentage,
  });

  MyPublicTestRatingDistributionEntity toEntity() {
    return MyPublicTestRatingDistributionEntity(
      stars: stars,
      count: count,
      percentage: percentage,
    );
  }
}

class MyPublicTestReviewModel {
  final int id;
  final int rating;
  final String reviewText;
  final String createdAt;
  final int yesCount;
  final MyPublicTestReviewUserModel reviewer;
  final MyPublicTestReviewViewerFeedbackModel? viewerFeedback;

  const MyPublicTestReviewModel({
    required this.id,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.yesCount,
    required this.reviewer,
    required this.viewerFeedback,
  });

  factory MyPublicTestReviewModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestReviewModel(
      id: _asInt(json['id']),
      rating: _asInt(json['rating']),
      reviewText: json['review_text']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      yesCount: _asInt(json['yes_count']),
      reviewer: MyPublicTestReviewUserModel.fromJson(
        (json['reviewer'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      viewerFeedback: json['viewer_feedback'] == null
          ? null
          : MyPublicTestReviewViewerFeedbackModel.fromJson(
              (json['viewer_feedback'] as Map?)?.cast<String, dynamic>() ?? {},
            ),
    );
  }

  MyPublicTestReviewEntity toEntity() {
    return MyPublicTestReviewEntity(
      id: id,
      rating: rating,
      reviewText: reviewText,
      createdAt: createdAt,
      yesCount: yesCount,
      reviewer: reviewer.toEntity(),
      viewerFeedback: viewerFeedback?.toEntity(),
    );
  }
}

class MyPublicTestReviewUserModel {
  final int id;
  final String name;
  final String avatarUrl;
  final bool isAcademicallyVerified;

  const MyPublicTestReviewUserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isAcademicallyVerified,
  });

  factory MyPublicTestReviewUserModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestReviewUserModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      isAcademicallyVerified: json['is_academically_verified'] == true,
    );
  }

  MyPublicTestReviewUserEntity toEntity() {
    return MyPublicTestReviewUserEntity(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      isAcademicallyVerified: isAcademicallyVerified,
    );
  }
}

class MyPublicTestReviewViewerFeedbackModel {
  final bool hasVoted;
  final String? vote;

  const MyPublicTestReviewViewerFeedbackModel({
    required this.hasVoted,
    required this.vote,
  });

  factory MyPublicTestReviewViewerFeedbackModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPublicTestReviewViewerFeedbackModel(
      hasVoted: json['has_voted'] == true,
      vote: _asNullableString(json['vote']),
    );
  }

  MyPublicTestReviewViewerFeedbackEntity toEntity() {
    return MyPublicTestReviewViewerFeedbackEntity(
      hasVoted: hasVoted,
      vote: vote,
    );
  }
}

class MyPublicTestReviewsMetaModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const MyPublicTestReviewsMetaModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });

  factory MyPublicTestReviewsMetaModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestReviewsMetaModel(
      currentPage: _asInt(json['current_page']),
      perPage: _asInt(json['per_page']),
      total: _asInt(json['total']),
      lastPage: _asInt(json['last_page']),
      hasMorePages: json['has_more_pages'] == true,
    );
  }

  MyPublicTestReviewsMetaEntity toEntity() {
    return MyPublicTestReviewsMetaEntity(
      currentPage: currentPage,
      perPage: perPage,
      total: total,
      lastPage: lastPage,
      hasMorePages: hasMorePages,
    );
  }
}

List<MyPublicTestRatingDistributionModel> _parseRatingDistribution(
  dynamic value,
) {
  final map = (value as Map?)?.cast<String, dynamic>() ?? {};

  return [5, 4, 3, 2, 1].map((star) {
    final item = (map['$star'] as Map?)?.cast<String, dynamic>() ?? {};

    return MyPublicTestRatingDistributionModel(
      stars: star,
      count: _asInt(item['count']),
      percentage: _asDouble(item['percentage']),
    );
  }).toList();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty) return null;
  if (text == 'null') return null;

  return text;
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}