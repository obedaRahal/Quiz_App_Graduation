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
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
      data: TestDetailsOverviewDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
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
      id: json['id'] as int? ?? 0,
      basicInfo: TestBasicInfoModel.fromJson(
        json['basic_info'] as Map<String, dynamic>? ?? {},
      ),
      creator: TestCreatorModel.fromJson(
        json['creator'] as Map<String, dynamic>? ?? {},
      ),
      extraInfo: TestExtraInfoModel.fromJson(
        json['extra_info'] as Map<String, dynamic>? ?? {},
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
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      likesCount: json['likes_count'] as int? ?? 0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      bookmarksCount: json['bookmarks_count'] as int? ?? 0,
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
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      isAcademicallyVerified: json['is_academically_verified'] as bool? ?? false,
      followersCount: json['followers_count'] as int? ?? 0,
      followingCount: json['following_count'] as int? ?? 0,
      publishedTestsCount: json['published_tests_count'] as int? ?? 0,
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
    final interestsJson = json['interests'] as List<dynamic>? ?? [];

    return TestExtraInfoModel(
      questionCount: json['question_count'] as int? ?? 0,
      durationSeconds: json['duration_seconds'] as int?,
      passMarkPercentage: json['pass_mark_percentage'] as int?,
      publishedAt: json['published_at']?.toString() ?? '',
      lastContentUpdatedAt: json['last_content_updated_at']?.toString() ?? '',
      targetLevel: json['target_level']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      participantsCount: json['participants_count'] as int? ?? 0,
      reviewStatus: json['review_status']?.toString() ?? '',
      interests: interestsJson
          .map(
            (item) => TestInterestModel.fromJson(
              item as Map<String, dynamic>? ?? {},
            ),
          )
          .toList(),
      viewerContext: TestViewerContextModel.fromJson(
        json['viewer_context'] as Map<String, dynamic>? ?? {},
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
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  TestInterestEntity toEntity() {
    return TestInterestEntity(
      id: id,
      name: name,
    );
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

  const TestViewerContextModel({
    required this.isOwner,
    required this.isFree,
    required this.isPaid,
    required this.hasPurchased,
    required this.isFollowingCreator,
    required this.canPurchase,
    required this.canDownload,
    required this.canReport,
  });

  factory TestViewerContextModel.fromJson(Map<String, dynamic> json) {
    return TestViewerContextModel(
      isOwner: json['is_owner'] as bool? ?? false,
      isFree: json['is_free'] as bool? ?? false,
      isPaid: json['is_paid'] as bool? ?? false,
      hasPurchased: json['has_purchased'] as bool? ?? false,
      isFollowingCreator: json['is_following_creator'] as bool? ?? false,
      canPurchase: json['can_purchase'] as bool? ?? false,
      canDownload: json['can_download'] as bool? ?? false,
      canReport: json['can_report'] as bool? ?? false,
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
    );
  }
}