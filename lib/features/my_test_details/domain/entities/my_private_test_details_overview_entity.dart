class MyPrivateTestDetailsOverviewEntity {
  final bool success;
  final String title;
  final MyPrivateTestDetailsDataEntity data;
  final int statusCode;

  const MyPrivateTestDetailsOverviewEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  MyPrivateTestDetailsOverviewEntity copyWith({
    bool? success,
    String? title,
    MyPrivateTestDetailsDataEntity? data,
    int? statusCode,
  }) {
    return MyPrivateTestDetailsOverviewEntity(
      success: success ?? this.success,
      title: title ?? this.title,
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class MyPrivateTestDetailsDataEntity {
  final int id;
  final MyPrivateTestBasicInfoEntity basicInfo;
  final MyPrivateTestExtraInfoEntity extraInfo;
  final MyPrivateTestViewerContextEntity viewerContext;

  const MyPrivateTestDetailsDataEntity({
    required this.id,
    required this.basicInfo,
    required this.extraInfo,
    required this.viewerContext,
  });

  MyPrivateTestDetailsDataEntity copyWith({
    int? id,
    MyPrivateTestBasicInfoEntity? basicInfo,
    MyPrivateTestExtraInfoEntity? extraInfo,
    MyPrivateTestViewerContextEntity? viewerContext,
  }) {
    return MyPrivateTestDetailsDataEntity(
      id: id ?? this.id,
      basicInfo: basicInfo ?? this.basicInfo,
      extraInfo: extraInfo ?? this.extraInfo,
      viewerContext: viewerContext ?? this.viewerContext,
    );
  }
}

class MyPrivateTestBasicInfoEntity {
  final String title;
  final String description;
  final String difficultyLevel;

  const MyPrivateTestBasicInfoEntity({
    required this.title,
    required this.description,
    required this.difficultyLevel,
  });

  MyPrivateTestBasicInfoEntity copyWith({
    String? title,
    String? description,
    String? difficultyLevel,
  }) {
    return MyPrivateTestBasicInfoEntity(
      title: title ?? this.title,
      description: description ?? this.description,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
    );
  }
}

class MyPrivateTestExtraInfoEntity {
  final int questionCount;

  /// قد تأتي من الـ backend كرقم أو نص مثل: "غير محدد".
  final dynamic rawDurationSeconds;

  /// تستخدم مع الودجت القديمة التي تتوقع int?.
  final int? durationSeconds;

  /// تستخدم إذا احتجنا عرض النص كما هو.
  final String durationText;

  final int? passMarkPercentage;
  final String publishedAt;
  final String lastContentUpdatedAt;
  final String targetLevel;
  final String language;
  final List<MyPrivateTestInterestEntity> interests;

  const MyPrivateTestExtraInfoEntity({
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

  MyPrivateTestExtraInfoEntity copyWith({
    int? questionCount,
    dynamic rawDurationSeconds,
    int? durationSeconds,
    String? durationText,
    int? passMarkPercentage,
    String? publishedAt,
    String? lastContentUpdatedAt,
    String? targetLevel,
    String? language,
    List<MyPrivateTestInterestEntity>? interests,
  }) {
    return MyPrivateTestExtraInfoEntity(
      questionCount: questionCount ?? this.questionCount,
      rawDurationSeconds: rawDurationSeconds ?? this.rawDurationSeconds,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      durationText: durationText ?? this.durationText,
      passMarkPercentage: passMarkPercentage ?? this.passMarkPercentage,
      publishedAt: publishedAt ?? this.publishedAt,
      lastContentUpdatedAt:
          lastContentUpdatedAt ?? this.lastContentUpdatedAt,
      targetLevel: targetLevel ?? this.targetLevel,
      language: language ?? this.language,
      interests: interests ?? this.interests,
    );
  }
}

class MyPrivateTestInterestEntity {
  final int id;
  final String name;

  const MyPrivateTestInterestEntity({
    required this.id,
    required this.name,
  });
}

class MyPrivateTestViewerContextEntity {
  final bool isOwner;
  final bool isFree;
  final bool isPaid;
  final bool isPrivate;
  final bool canPurchase;
  final bool canDownload;
  final bool canReport;
  final bool canShare;

  const MyPrivateTestViewerContextEntity({
    required this.isOwner,
    required this.isFree,
    required this.isPaid,
    required this.isPrivate,
    required this.canPurchase,
    required this.canDownload,
    required this.canReport,
    required this.canShare,
  });

  MyPrivateTestViewerContextEntity copyWith({
    bool? isOwner,
    bool? isFree,
    bool? isPaid,
    bool? isPrivate,
    bool? canPurchase,
    bool? canDownload,
    bool? canReport,
    bool? canShare,
  }) {
    return MyPrivateTestViewerContextEntity(
      isOwner: isOwner ?? this.isOwner,
      isFree: isFree ?? this.isFree,
      isPaid: isPaid ?? this.isPaid,
      isPrivate: isPrivate ?? this.isPrivate,
      canPurchase: canPurchase ?? this.canPurchase,
      canDownload: canDownload ?? this.canDownload,
      canReport: canReport ?? this.canReport,
      canShare: canShare ?? this.canShare,
    );
  }
}