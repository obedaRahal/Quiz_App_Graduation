import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_details_overview_entity.dart';

class MyPublicTestDetailsOverviewModel {
  final bool success;
  final String title;
  final MyPublicTestDetailsDataModel data;
  final int statusCode;

  const MyPublicTestDetailsOverviewModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory MyPublicTestDetailsOverviewModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPublicTestDetailsOverviewModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: MyPublicTestDetailsDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code']),
    );
  }

  MyPublicTestDetailsOverviewEntity toEntity() {
    return MyPublicTestDetailsOverviewEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class MyPublicTestDetailsDataModel {
  final int id;
  final MyPublicTestBasicInfoModel basicInfo;
  final MyPublicTestExtraInfoModel extraInfo;
  final MyPublicTestViewerContextModel viewerContext;

  const MyPublicTestDetailsDataModel({
    required this.id,
    required this.basicInfo,
    required this.extraInfo,
    required this.viewerContext,
  });

  factory MyPublicTestDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestDetailsDataModel(
      id: _asInt(json['id']),
      basicInfo: MyPublicTestBasicInfoModel.fromJson(
        (json['basic_info'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      extraInfo: MyPublicTestExtraInfoModel.fromJson(
        (json['extra_info'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      viewerContext: MyPublicTestViewerContextModel.fromJson(
        (json['viewer_context'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  MyPublicTestDetailsDataEntity toEntity() {
    return MyPublicTestDetailsDataEntity(
      id: id,
      basicInfo: basicInfo.toEntity(),
      extraInfo: extraInfo.toEntity(),
      viewerContext: viewerContext.toEntity(),
    );
  }
}

class MyPublicTestBasicInfoModel {
  final String title;
  final String description;
  final String difficultyLevel;
  final double price;
  final int likesCount;
  final int reviewsCount;
  final int bookmarksCount;

  const MyPublicTestBasicInfoModel({
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.price,
    required this.likesCount,
    required this.reviewsCount,
    required this.bookmarksCount,
  });

  factory MyPublicTestBasicInfoModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestBasicInfoModel(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      difficultyLevel: json['difficulty_level']?.toString() ?? '',
      price: _asDouble(json['price']),
      likesCount: _asInt(json['likes_count']),
      reviewsCount: _asInt(json['reviews_count']),
      bookmarksCount: _asInt(json['bookmarks_count']),
    );
  }

  MyPublicTestBasicInfoEntity toEntity() {
    return MyPublicTestBasicInfoEntity(
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

class MyPublicTestExtraInfoModel {
  final int questionCount;
  final dynamic rawDurationSeconds;
  final int? durationSeconds;
  final String durationText;
  final int? passMarkPercentage;
  final String publishedAt;
  final String lastContentUpdatedAt;
  final String targetLevel;
  final String language;
  final int participantsCount;
  final List<MyPublicTestInterestModel> interests;
  final List<MyPublicTestPreviewQuestionModel> previewQuestions;

  const MyPublicTestExtraInfoModel({
    required this.questionCount,
    required this.rawDurationSeconds,
    required this.durationSeconds,
    required this.durationText,
    required this.passMarkPercentage,
    required this.publishedAt,
    required this.lastContentUpdatedAt,
    required this.targetLevel,
    required this.language,
    required this.participantsCount,
    required this.interests,
    required this.previewQuestions,
  });

  factory MyPublicTestExtraInfoModel.fromJson(Map<String, dynamic> json) {
    final rawDuration = json['duration_seconds'];
    final parsedDuration = _asNullableInt(rawDuration);

    return MyPublicTestExtraInfoModel(
      questionCount: _asInt(json['question_count']),
      rawDurationSeconds: rawDuration,
      durationSeconds: parsedDuration,
      durationText: rawDuration?.toString() ?? 'غير محدد',
      passMarkPercentage: _asNullableInt(json['pass_mark_percentage']),
      publishedAt: json['published_at']?.toString() ?? '',
      lastContentUpdatedAt:
          json['last_content_updated_at']?.toString() ?? '',
      targetLevel: json['target_level']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      participantsCount: _asInt(json['participants_count']),
      interests: _asList(json['interests'])
          .map((item) => MyPublicTestInterestModel.fromJson(item))
          .toList(),
      previewQuestions: _asList(json['preview_questions'])
          .map((item) => MyPublicTestPreviewQuestionModel.fromJson(item))
          .toList(),
    );
  }

  MyPublicTestExtraInfoEntity toEntity() {
    return MyPublicTestExtraInfoEntity(
      questionCount: questionCount,
      rawDurationSeconds: rawDurationSeconds,
      durationSeconds: durationSeconds,
      durationText: durationText,
      passMarkPercentage: passMarkPercentage,
      publishedAt: publishedAt,
      lastContentUpdatedAt: lastContentUpdatedAt,
      targetLevel: targetLevel,
      language: language,
      participantsCount: participantsCount,
      interests: interests.map((item) => item.toEntity()).toList(),
      previewQuestions:
          previewQuestions.map((item) => item.toEntity()).toList(),
    );
  }
}

class MyPublicTestInterestModel {
  final int id;
  final String name;

  const MyPublicTestInterestModel({
    required this.id,
    required this.name,
  });

  factory MyPublicTestInterestModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestInterestModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }

  MyPublicTestInterestEntity toEntity() {
    return MyPublicTestInterestEntity(
      id: id,
      name: name,
    );
  }
}

class MyPublicTestPreviewQuestionModel {
  final int id;
  final int position;
  final String questionText;
  final String? hintText;
  final List<MyPublicTestPreviewOptionModel> options;

  const MyPublicTestPreviewQuestionModel({
    required this.id,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.options,
  });

  factory MyPublicTestPreviewQuestionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPublicTestPreviewQuestionModel(
      id: _asInt(json['id']),
      position: _asInt(json['position']),
      questionText: json['question_text']?.toString() ?? '',
      hintText: _asNullableString(json['hint_text']),
      options: _asList(json['options'])
          .map((item) => MyPublicTestPreviewOptionModel.fromJson(item))
          .toList(),
    );
  }

  MyPublicTestPreviewQuestionEntity toEntity() {
    return MyPublicTestPreviewQuestionEntity(
      id: id,
      position: position,
      questionText: questionText,
      hintText: hintText,
      options: options.map((item) => item.toEntity()).toList(),
    );
  }
}

class MyPublicTestPreviewOptionModel {
  final int id;
  final int position;
  final String optionText;
  final bool isCorrect;

  const MyPublicTestPreviewOptionModel({
    required this.id,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });

  factory MyPublicTestPreviewOptionModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestPreviewOptionModel(
      id: _asInt(json['id']),
      position: _asInt(json['position']),
      optionText: json['option_text']?.toString() ?? '',
      isCorrect: json['is_correct'] == true,
    );
  }

  MyPublicTestPreviewOptionEntity toEntity() {
    return MyPublicTestPreviewOptionEntity(
      id: id,
      position: position,
      optionText: optionText,
      isCorrect: isCorrect,
    );
  }
}

class MyPublicTestViewerContextModel {
  final bool isOwner;
  final bool isFree;
  final bool isPaid;
  final bool isPrivate;
  final bool canPurchase;
  final bool canDownload;
  final bool canReport;
  final bool canShare;

  const MyPublicTestViewerContextModel({
    required this.isOwner,
    required this.isFree,
    required this.isPaid,
    required this.isPrivate,
    required this.canPurchase,
    required this.canDownload,
    required this.canReport,
    required this.canShare,
  });

  factory MyPublicTestViewerContextModel.fromJson(Map<String, dynamic> json) {
    return MyPublicTestViewerContextModel(
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

  MyPublicTestViewerContextEntity toEntity() {
    return MyPublicTestViewerContextEntity(
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

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
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