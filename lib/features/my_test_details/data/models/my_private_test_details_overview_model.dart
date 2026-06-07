import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_private_test_details_overview_entity.dart';

class MyPrivateTestDetailsOverviewModel {
  final bool success;
  final String title;
  final MyPrivateTestDetailsDataModel data;
  final int statusCode;

  const MyPrivateTestDetailsOverviewModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory MyPrivateTestDetailsOverviewModel.fromJson(Map<String, dynamic> json) {
    return MyPrivateTestDetailsOverviewModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: MyPrivateTestDetailsDataModel.fromJson(json['data'] ?? {}),
      statusCode: (json['status_code'] ?? 200) as int,
    );
  }

  MyPrivateTestDetailsOverviewEntity toEntity() {
    return MyPrivateTestDetailsOverviewEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class MyPrivateTestDetailsDataModel {
  final int id;
  final MyPrivateTestBasicInfoModel basicInfo;
  final MyPrivateTestExtraInfoModel extraInfo;
  final MyPrivateTestViewerContextModel viewerContext;

  const MyPrivateTestDetailsDataModel({
    required this.id,
    required this.basicInfo,
    required this.extraInfo,
    required this.viewerContext,
  });

  factory MyPrivateTestDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return MyPrivateTestDetailsDataModel(
      id: (json['id'] ?? 0) as int,
      basicInfo: MyPrivateTestBasicInfoModel.fromJson(json['basic_info'] ?? {}),
      extraInfo: MyPrivateTestExtraInfoModel.fromJson(json['extra_info'] ?? {}),
      viewerContext:
          MyPrivateTestViewerContextModel.fromJson(json['viewer_context'] ?? {}),
    );
  }

  MyPrivateTestDetailsDataEntity toEntity() {
    return MyPrivateTestDetailsDataEntity(
      id: id,
      basicInfo: basicInfo.toEntity(),
      extraInfo: extraInfo.toEntity(),
      viewerContext: viewerContext.toEntity(),
    );
  }
}

class MyPrivateTestBasicInfoModel {
  final String title;
  final String description;
  final String difficultyLevel;

  const MyPrivateTestBasicInfoModel({
    required this.title,
    required this.description,
    required this.difficultyLevel,
  });

  factory MyPrivateTestBasicInfoModel.fromJson(Map<String, dynamic> json) {
    return MyPrivateTestBasicInfoModel(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      difficultyLevel: json['difficulty_level']?.toString() ?? '',
    );
  }

  MyPrivateTestBasicInfoEntity toEntity() {
    return MyPrivateTestBasicInfoEntity(
      title: title,
      description: description,
      difficultyLevel: difficultyLevel,
    );
  }
}

class MyPrivateTestExtraInfoModel {
  final int questionCount;
  final dynamic rawDurationSeconds;
  final int? durationSeconds;
  final String durationText;
  final int? passMarkPercentage;
  final String publishedAt;
  final String lastContentUpdatedAt;
  final String targetLevel;
  final String language;
  final List<MyPrivateTestInterestModel> interests;

  const MyPrivateTestExtraInfoModel({
    required this.questionCount,
    required this.rawDurationSeconds,
    required this.durationSeconds,
    required this.durationText,
    required this.passMarkPercentage,
    required this.publishedAt,
    required this.lastContentUpdatedAt,
    required this.targetLevel,
    required this.language,
    required this.interests,
  });

  factory MyPrivateTestExtraInfoModel.fromJson(Map<String, dynamic> json) {
    final interests = (json['interests'] as List?)
            ?.map((e) => MyPrivateTestInterestModel.fromJson(e))
            .toList() ??
        [];

    return MyPrivateTestExtraInfoModel(
      questionCount: (json['question_count'] ?? 0) as int,
      rawDurationSeconds: json['duration_seconds'],
      durationSeconds: null, // يمكن حسابها لاحقًا
      durationText: json['duration_seconds']?.toString() ?? 'غير محدد',
      passMarkPercentage: json['pass_mark_percentage'] != null
          ? (json['pass_mark_percentage'] as int)
          : null,
      publishedAt: json['published_at']?.toString() ?? '',
      lastContentUpdatedAt: json['last_content_updated_at']?.toString() ?? '',
      targetLevel: json['target_level']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      interests: interests,
    );
  }

  MyPrivateTestExtraInfoEntity toEntity() {
    return MyPrivateTestExtraInfoEntity(
      questionCount: questionCount,
      rawDurationSeconds: rawDurationSeconds,
      durationSeconds: durationSeconds,
      durationText: durationText,
      passMarkPercentage: passMarkPercentage,
      publishedAt: publishedAt,
      lastContentUpdatedAt: lastContentUpdatedAt,
      targetLevel: targetLevel,
      language: language,
      interests: interests.map((e) => e.toEntity()).toList(),
    );
  }
}

class MyPrivateTestInterestModel {
  final int id;
  final String name;

  const MyPrivateTestInterestModel({
    required this.id,
    required this.name,
  });

  factory MyPrivateTestInterestModel.fromJson(Map<String, dynamic> json) {
    return MyPrivateTestInterestModel(
      id: (json['id'] ?? 0) as int,
      name: json['name']?.toString() ?? '',
    );
  }

  MyPrivateTestInterestEntity toEntity() {
    return MyPrivateTestInterestEntity(
      id: id,
      name: name,
    );
  }
}

class MyPrivateTestViewerContextModel {
  final bool isOwner;
  final bool isFree;
  final bool isPaid;
  final bool isPrivate;
  final bool canPurchase;
  final bool canDownload;
  final bool canReport;
  final bool canShare;

  const MyPrivateTestViewerContextModel({
    required this.isOwner,
    required this.isFree,
    required this.isPaid,
    required this.isPrivate,
    required this.canPurchase,
    required this.canDownload,
    required this.canReport,
    required this.canShare,
  });

  factory MyPrivateTestViewerContextModel.fromJson(Map<String, dynamic> json) {
    return MyPrivateTestViewerContextModel(
      isOwner: json['is_owner'] == true,
      isFree: json['is_free'] == true,
      isPaid: json['is_paid'] == true,
      isPrivate: json['is_private'] == true,
      canPurchase: json['can_purchase'] == true,
      canDownload: json['can_download'] == true,
      canReport: json['can_report'] == true,
      canShare: json['can_share'] == true,
    );
  }

  MyPrivateTestViewerContextEntity toEntity() {
    return MyPrivateTestViewerContextEntity(
      isOwner: isOwner,
      isFree: isFree,
      isPaid: isPaid,
      isPrivate: isPrivate,
      canPurchase: canPurchase,
      canDownload: canDownload,
      canReport: canReport,
      canShare: canShare,
    );
  }
}