class MyPublicTestDetailsOverviewEntity {
  final bool success;
  final String title;
  final MyPublicTestDetailsDataEntity data;
  final int statusCode;

  const MyPublicTestDetailsOverviewEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  MyPublicTestDetailsOverviewEntity copyWith({
    bool? success,
    String? title,
    MyPublicTestDetailsDataEntity? data,
    int? statusCode,
  }) {
    return MyPublicTestDetailsOverviewEntity(
      success: success ?? this.success,
      title: title ?? this.title,
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class MyPublicTestDetailsDataEntity {
  final int id;
  final MyPublicTestBasicInfoEntity basicInfo;
  final MyPublicTestExtraInfoEntity extraInfo;
  final MyPublicTestViewerContextEntity viewerContext;

  const MyPublicTestDetailsDataEntity({
    required this.id,
    required this.basicInfo,
    required this.extraInfo,
    required this.viewerContext,
  });

  MyPublicTestDetailsDataEntity copyWith({
    int? id,
    MyPublicTestBasicInfoEntity? basicInfo,
    MyPublicTestExtraInfoEntity? extraInfo,
    MyPublicTestViewerContextEntity? viewerContext,
  }) {
    return MyPublicTestDetailsDataEntity(
      id: id ?? this.id,
      basicInfo: basicInfo ?? this.basicInfo,
      extraInfo: extraInfo ?? this.extraInfo,
      viewerContext: viewerContext ?? this.viewerContext,
    );
  }
}

class MyPublicTestBasicInfoEntity {
  final String title;
  final String description;
  final String difficultyLevel;
  final double price;
  final int likesCount;
  final int reviewsCount;
  final int bookmarksCount;

  const MyPublicTestBasicInfoEntity({
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.price,
    required this.likesCount,
    required this.reviewsCount,
    required this.bookmarksCount,
  });

  MyPublicTestBasicInfoEntity copyWith({
    String? title,
    String? description,
    String? difficultyLevel,
    double? price,
    int? likesCount,
    int? reviewsCount,
    int? bookmarksCount,
  }) {
    return MyPublicTestBasicInfoEntity(
      title: title ?? this.title,
      description: description ?? this.description,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      price: price ?? this.price,
      likesCount: likesCount ?? this.likesCount,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
    );
  }
}

class MyPublicTestExtraInfoEntity {
  final int questionCount;

  /// نحافظ على القيمة الخام لأنها قد تأتي رقمًا أو نصًا مثل: "غير محدد".
  final dynamic rawDurationSeconds;

  /// هذه تستخدم مع الواجهات الحالية التي تتوقع int?.
  final int? durationSeconds;

  /// هذه تستخدم إذا أردنا عرض النص كما جاء من الـ backend.
  final String durationText;

  final int? passMarkPercentage;
  final String publishedAt;
  final String lastContentUpdatedAt;
  final String targetLevel;
  final String language;
  final int participantsCount;
  final List<MyPublicTestInterestEntity> interests;
  final List<MyPublicTestPreviewQuestionEntity> previewQuestions;

  const MyPublicTestExtraInfoEntity({
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

  MyPublicTestExtraInfoEntity copyWith({
    int? questionCount,
    dynamic rawDurationSeconds,
    int? durationSeconds,
    String? durationText,
    int? passMarkPercentage,
    String? publishedAt,
    String? lastContentUpdatedAt,
    String? targetLevel,
    String? language,
    int? participantsCount,
    List<MyPublicTestInterestEntity>? interests,
    List<MyPublicTestPreviewQuestionEntity>? previewQuestions,
  }) {
    return MyPublicTestExtraInfoEntity(
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
      participantsCount: participantsCount ?? this.participantsCount,
      interests: interests ?? this.interests,
      previewQuestions: previewQuestions ?? this.previewQuestions,
    );
  }
}

class MyPublicTestInterestEntity {
  final int id;
  final String name;

  const MyPublicTestInterestEntity({
    required this.id,
    required this.name,
  });
}

class MyPublicTestPreviewQuestionEntity {
  final int id;
  final int position;
  final String questionText;
  final String? hintText;
  final List<MyPublicTestPreviewOptionEntity> options;

  const MyPublicTestPreviewQuestionEntity({
    required this.id,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.options,
  });
}

class MyPublicTestPreviewOptionEntity {
  final int id;
  final int position;
  final String optionText;
  final bool isCorrect;

  const MyPublicTestPreviewOptionEntity({
    required this.id,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });
}

class MyPublicTestViewerContextEntity {
  final bool isOwner;
  final bool isFree;
  final bool isPaid;
  final bool isPrivate;
  final bool canPurchase;
  final bool canDownload;
  final bool canReport;
  final bool canShare;

  const MyPublicTestViewerContextEntity({
    required this.isOwner,
    required this.isFree,
    required this.isPaid,
    required this.isPrivate,
    required this.canPurchase,
    required this.canDownload,
    required this.canReport,
    required this.canShare,
  });

  MyPublicTestViewerContextEntity copyWith({
    bool? isOwner,
    bool? isFree,
    bool? isPaid,
    bool? isPrivate,
    bool? canPurchase,
    bool? canDownload,
    bool? canReport,
    bool? canShare,
  }) {
    return MyPublicTestViewerContextEntity(
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