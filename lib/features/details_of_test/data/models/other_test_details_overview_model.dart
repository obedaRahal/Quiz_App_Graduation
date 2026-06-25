import 'package:quiz_app_grad/core/utils/compact_count_formatter.dart';

import '../../domain/entities/other_test_details_overview_entity.dart';

class OtherTestDetailsOverviewModel {
  final bool success;
  final String title;
  final int statusCode;
  final TestDetailsOverviewDataModel data;

  const OtherTestDetailsOverviewModel({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.data,
  });

  factory OtherTestDetailsOverviewModel.fromJson(Map<String, dynamic> json) {
    return OtherTestDetailsOverviewModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      statusCode: _asInt(json['status_code']),
      data: TestDetailsOverviewDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  OtherTestDetailsOverviewEntity toEntity() {
    return OtherTestDetailsOverviewEntity(
      success: success,
      title: title,
      statusCode: statusCode,
      data: data.toEntity(),
    );
  }
}

class TestDetailsOverviewDataModel {
  final int id;
  final TestBasicInfoModel basicInfo;
  final TestCreatorModel creator;
  final TestExtraInfoModel extraInfo;

  const TestDetailsOverviewDataModel({
    required this.id,
    required this.basicInfo,
    required this.creator,
    required this.extraInfo,
  });

  factory TestDetailsOverviewDataModel.fromJson(Map<String, dynamic> json) {
    return TestDetailsOverviewDataModel(
      id: _asInt(json['id']),
      basicInfo: TestBasicInfoModel.fromJson(
        (json['basic_info'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      creator: TestCreatorModel.fromJson(
        (json['creator'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      extraInfo: TestExtraInfoModel.fromJson(
        (json['extra_info'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  TestDetailsOverviewDataEntity toEntity() {
    return TestDetailsOverviewDataEntity(
      id: id,
      basicInfo: basicInfo.toEntity(),
      creator: creator.toEntity(),
      extraInfo: extraInfo.toEntity(),
    );
  }
}

class TestBasicInfoModel {
  final String title;
  final String description;
  final String difficultyLevel;
  final double price;
  final int likesCount;
  final int reviewsCount;
  final int bookmarksCount;

  const TestBasicInfoModel({
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.price,
    required this.likesCount,
    required this.reviewsCount,
    required this.bookmarksCount,
  });

  factory TestBasicInfoModel.fromJson(Map<String, dynamic> json) {
    return TestBasicInfoModel(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      difficultyLevel: json['difficulty_level']?.toString() ?? '',
      price: _asDouble(json['price']),
      likesCount: parseCompactCount(json['likes_count']),
      reviewsCount: parseCompactCount(json['reviews_count']),
      bookmarksCount: parseCompactCount(json['bookmarks_count']),
    );
  }

  TestBasicInfoEntity toEntity() {
    return TestBasicInfoEntity(
      title: title,
      description: description,
      difficultyLevel: difficultyLevel,
      price: price,
      likesCount: likesCount,
      reviewsCount: reviewsCount,
      bookmarksCount: bookmarksCount,
    );
  }
}

class TestCreatorModel {
  final int id;
  final String name;
  final bool isAcademicallyVerified;
  final int followersCount;
  final int followingCount;
  final int publishedTestsCount;
  final String profilePicture;

  const TestCreatorModel({
    required this.id,
    required this.name,
    required this.isAcademicallyVerified,
    required this.followersCount,
    required this.followingCount,
    required this.publishedTestsCount,
    required this.profilePicture,
  });

  factory TestCreatorModel.fromJson(Map<String, dynamic> json) {
    return TestCreatorModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      isAcademicallyVerified: json['is_academically_verified'] == true,
      followersCount: parseCompactCount(json['followers_count']),
      followingCount: parseCompactCount(json['following_count']),
      publishedTestsCount: parseCompactCount(json['published_tests_count']),
      profilePicture: json['profile_picture']?.toString() ?? '',
    );
  }

  TestCreatorEntity toEntity() {
    return TestCreatorEntity(
      id: id,
      name: name,
      isAcademicallyVerified: isAcademicallyVerified,
      followersCount: followersCount,
      followingCount: followingCount,
      publishedTestsCount: publishedTestsCount,
      profilePicture: profilePicture,
    );
  }
}

class TestExtraInfoModel {
  final int questionCount;
  final int? durationSeconds;
  final int? passMarkPercentage;
  final String publishedAt;
  final String lastContentUpdatedAt;
  final String targetLevel;
  final String language;
  final int participantsCount;
  final String reviewStatus;
  final List<TestInterestModel> interests;
  final TestViewerContextModel viewerContext;

  const TestExtraInfoModel({
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

  factory TestExtraInfoModel.fromJson(Map<String, dynamic> json) {
    return TestExtraInfoModel(
      questionCount: _asInt(json['question_count']),
      durationSeconds: _asNullableInt(json['duration_seconds']),
      passMarkPercentage: _asNullableInt(json['pass_mark_percentage']),
      publishedAt: json['published_at']?.toString() ?? '',
      lastContentUpdatedAt: json['last_content_updated_at']?.toString() ?? '',
      targetLevel: json['target_level']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      participantsCount: _asInt(json['participants_count']),
      reviewStatus: json['review_status']?.toString() ?? '',
      interests: _asList(json['interests'])
          .map((item) => TestInterestModel.fromJson(item))
          .toList(),
      viewerContext: TestViewerContextModel.fromJson(
        (json['viewer_context'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  TestExtraInfoEntity toEntity() {
    return TestExtraInfoEntity(
      questionCount: questionCount,
      durationSeconds: durationSeconds,
      passMarkPercentage: passMarkPercentage,
      publishedAt: publishedAt,
      lastContentUpdatedAt: lastContentUpdatedAt,
      targetLevel: targetLevel,
      language: language,
      participantsCount: participantsCount,
      reviewStatus: reviewStatus,
      interests: interests.map((item) => item.toEntity()).toList(),
      viewerContext: viewerContext.toEntity(),
    );
  }
}

class TestInterestModel {
  final int id;
  final String name;

  const TestInterestModel({
    required this.id,
    required this.name,
  });

  factory TestInterestModel.fromJson(Map<String, dynamic> json) {
    return TestInterestModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }

  TestInterestEntity toEntity() {
    return TestInterestEntity(id: id, name: name);
  }
}

class TestViewerContextModel {
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
  final bool isAttemptIt;

  const TestViewerContextModel({
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
    required this.isAttemptIt,
  });

  factory TestViewerContextModel.fromJson(Map<String, dynamic> json) {
    return TestViewerContextModel(
      isOwner: _asBool(json['is_owner']),
      isFree: _asBool(json['is_free']),
      isPaid: _asBool(json['is_paid']),
      hasPurchased: _asBool(json['has_purchased']),
      isFollowingCreator: _asBool(json['is_following_creator']),
      canPurchase: _asBool(json['can_purchase']),
      canDownload: _asBool(json['can_download']),
      canReport: _asBool(json['can_report']),
      hasLiked: _asBool(json['has_liked']),
      hasBookmarked: _asBool(json['has_bookmarked']),
      isAttemptIt: _asBool(json['is_Attempt_it']),
    );
  }

  TestViewerContextEntity toEntity() {
    return TestViewerContextEntity(
      isOwner: isOwner,
      isFree: isFree,
      isPaid: isPaid,
      hasPurchased: hasPurchased,
      isFollowingCreator: isFollowingCreator,
      canPurchase: canPurchase,
      canDownload: canDownload,
      canReport: canReport,
      hasLiked: hasLiked,
      hasBookmarked: hasBookmarked,
      isAttemptIt: isAttemptIt,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();

  if (value is String) {
    final text = value.trim();

    if (text.isEmpty) return fallback;
    if (text.toLowerCase() == 'null') return fallback;
    if (text == 'غير محدد') return fallback;

    return int.tryParse(text) ?? fallback;
  }

  return fallback;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();

  if (value is String) {
    final text = value.trim();

    if (text.isEmpty) return null;
    if (text.toLowerCase() == 'null') return null;
    if (text == 'غير محدد') return null;

    return int.tryParse(text);
  }

  return null;
}

double _asDouble(dynamic value, {double fallback = 0}) {
  if (value is double) return value;
  if (value is int) return value.toDouble();

  if (value is String) {
    final text = value.trim();

    if (text.isEmpty) return fallback;
    if (text.toLowerCase() == 'null') return fallback;
    if (text == 'غير محدد') return fallback;

    return double.tryParse(text) ?? fallback;
  }

  return fallback;
}

bool _asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;

  if (value is int) return value == 1;

  if (value is String) {
    final text = value.trim().toLowerCase();

    if (text == 'true') return true;
    if (text == '1') return true;
    if (text == 'yes') return true;

    if (text == 'false') return false;
    if (text == '0') return false;
    if (text == 'no') return false;
  }

  return fallback;
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}