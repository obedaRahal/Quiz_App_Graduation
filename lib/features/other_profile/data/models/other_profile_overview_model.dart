// lib/features/other_profile/data/models/other_profile_overview_model.dart

import 'package:quiz_app_grad/core/utils/compact_count_formatter.dart';

import '../../domain/entities/other_profile_overview_entity.dart';

class OtherProfileOverviewModel {
  final bool success;
  final String title;
  final OtherProfileOverviewDataModel data;
  final int statusCode;

  const OtherProfileOverviewModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory OtherProfileOverviewModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileOverviewModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: OtherProfileOverviewDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: parseCompactCount(json['status_code']),
    );
  }

  OtherProfileOverviewEntity toEntity() {
    return OtherProfileOverviewEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class OtherProfileOverviewDataModel {
  final OtherProfileHeaderModel header;
  final OtherProfileBasicInfoModel basicInfo;
  final OtherProfileReviewsModel reviews;
  final OtherProfileGeneralStatsModel generalStatistics;

  const OtherProfileOverviewDataModel({
    required this.header,
    required this.basicInfo,
    required this.reviews,
    required this.generalStatistics,
  });

  factory OtherProfileOverviewDataModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileOverviewDataModel(
      header: OtherProfileHeaderModel.fromJson(
        (json['header'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      basicInfo: OtherProfileBasicInfoModel.fromJson(
        (json['basic_info'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      reviews: OtherProfileReviewsModel.fromJson(
        (json['reviews'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      generalStatistics: OtherProfileGeneralStatsModel.fromJson(
        (json['general_statistics'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  OtherProfileOverviewDataEntity toEntity() {
    return OtherProfileOverviewDataEntity(
      header: header.toEntity(),
      basicInfo: basicInfo.toEntity(),
      reviews: reviews.toEntity(),
      generalStatistics: generalStatistics.toEntity(),
    );
  }
}

class OtherProfileHeaderModel {
  final int userId;
  final String name;
  final String avatarUrl;
  final String coverUrl;
  final int followersCount;
  final int followingCount;
  final int publishedTestsCount;
  final bool isAcademicallyVerified;
  final bool viewerIsFollowing;

  const OtherProfileHeaderModel({
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

  factory OtherProfileHeaderModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileHeaderModel(
      userId: parseCompactCount(json['user_id']),
      name: json['name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      coverUrl: json['cover_url']?.toString() ?? '',
      followersCount: parseCompactCount(json['followers_count']),
      followingCount: parseCompactCount(json['following_count']),
      publishedTestsCount: parseCompactCount(json['published_tests_count']),
      isAcademicallyVerified: json['is_academically_verified'] == true,
      viewerIsFollowing: json['viewer_is_following'] == true,
    );
  }

  OtherProfileHeaderEntity toEntity() {
    return OtherProfileHeaderEntity(
      userId: userId,
      name: name,
      avatarUrl: avatarUrl,
      coverUrl: coverUrl,
      followersCount: followersCount,
      followingCount: followingCount,
      publishedTestsCount: publishedTestsCount,
      isAcademicallyVerified: isAcademicallyVerified,
      viewerIsFollowing: viewerIsFollowing,
    );
  }
}

class OtherProfileBasicInfoModel {
  final String educationLevel;
  final String governorate;
  final String gender;
  final String joinedAt;
  final List<String> interests;

  const OtherProfileBasicInfoModel({
    required this.educationLevel,
    required this.governorate,
    required this.gender,
    required this.joinedAt,
    required this.interests,
  });

  factory OtherProfileBasicInfoModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileBasicInfoModel(
      educationLevel: json['education_level']?.toString() ?? '',
      governorate: json['governorate']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      joinedAt: json['joined_at']?.toString() ?? '',
      interests: _asList(json['interests']).map((e) => e.toString()).toList(),
    );
  }

  OtherProfileBasicInfoEntity toEntity() {
    return OtherProfileBasicInfoEntity(
      educationLevel: educationLevel,
      governorate: governorate,
      gender: gender,
      joinedAt: joinedAt,
      interests: interests,
    );
  }
}

class OtherProfileReviewsModel {
  final double averageRating;
  final int totalReviewsCount;
  final List<OtherProfileRatingDistributionModel> ratingDistribution;

  const OtherProfileReviewsModel({
    required this.averageRating,
    required this.totalReviewsCount,
    required this.ratingDistribution,
  });

  factory OtherProfileReviewsModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileReviewsModel(
      averageRating: _asDouble(json['average_rating']),
      totalReviewsCount: parseCompactCount(json['total_reviews_count']),
      ratingDistribution: _asMapList(json['rating_distribution'])
          .map((item) => OtherProfileRatingDistributionModel.fromJson(item))
          .toList(),
    );
  }

  OtherProfileReviewsEntity toEntity() {
    return OtherProfileReviewsEntity(
      averageRating: averageRating,
      totalReviewsCount: totalReviewsCount,
      ratingDistribution: ratingDistribution
          .map((item) => item.toEntity())
          .toList(),
    );
  }
}

class OtherProfileRatingDistributionModel {
  final int count;
  final int percentage;

  const OtherProfileRatingDistributionModel({
    required this.count,
    required this.percentage,
  });

  factory OtherProfileRatingDistributionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtherProfileRatingDistributionModel(
      count: parseCompactCount(json['count']),
      percentage: parseCompactCount(json['percentage']),
    );
  }

  OtherProfileRatingDistributionEntity toEntity() {
    return OtherProfileRatingDistributionEntity(
      count: count,
      percentage: percentage,
    );
  }
}

class OtherProfileGeneralStatsModel {
  final int testLikesCount;
  final int testCommentsCount;
  final int testBookmarksCount;

  const OtherProfileGeneralStatsModel({
    required this.testLikesCount,
    required this.testCommentsCount,
    required this.testBookmarksCount,
  });

  factory OtherProfileGeneralStatsModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileGeneralStatsModel(
      testLikesCount: parseCompactCount(json['test_likes_count']),
      testCommentsCount: parseCompactCount(json['test_comments_count']),
      testBookmarksCount: parseCompactCount(json['test_bookmarks_count']),
    );
  }

  OtherProfileGeneralStatsEntity toEntity() {
    return OtherProfileGeneralStatsEntity(
      testLikesCount: testLikesCount,
      testCommentsCount: testCommentsCount,
      testBookmarksCount: testBookmarksCount,
    );
  }
}

// --- Helpers المنيعة والمطابقة تماماً لملفك ---
// int _asInt(dynamic value) {
//   if (value is int) return value;
//   if (value is double) return value.toInt();
//   if (value is String) return int.tryParse(value) ?? 0;
//   return 0;
// }

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

List<dynamic> _asList(dynamic value) {
  if (value is List) return value;
  return [];
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];
  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}
