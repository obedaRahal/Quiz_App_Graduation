enum MyPublicTestStatusType {
  deleted,
  reported,
  approved,
  underReview,
  needsModification,
  draft,
  unknown,
}

class MyPublicTestStatusHistoryEntity {
  final bool success;
  final String title;
  final List<MyPublicTestStatusHistoryItemEntity> data;
  final int statusCode;

  const MyPublicTestStatusHistoryEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  MyPublicTestStatusHistoryEntity copyWith({
    bool? success,
    String? title,
    List<MyPublicTestStatusHistoryItemEntity>? data,
    int? statusCode,
  }) {
    return MyPublicTestStatusHistoryEntity(
      success: success ?? this.success,
      title: title ?? this.title,
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
    );
  }

  MyPublicTestStatusHistoryItemEntity? get currentStatus {
    if (data.isEmpty) return null;
    return data.first;
  }

  List<MyPublicTestStatusHistoryItemEntity> get previousStatuses {
    if (data.length <= 1) return const [];
    return data.skip(1).toList();
  }
}

class MyPublicTestStatusHistoryItemEntity {
  final int historyId;
  final int? roundId;
  final MyPublicTestStatusTransitionEntity status;
  final String description;
  final String happenedAt;

  const MyPublicTestStatusHistoryItemEntity({
    required this.historyId,
    required this.roundId,
    required this.status,
    required this.description,
    required this.happenedAt,
  });

  String get title => status.toStatus ?? 'غير معروف';

  MyPublicTestStatusType get type => mapStatusToType(title);

  MyPublicTestStatusHistoryItemEntity copyWith({
    int? historyId,
    int? roundId,
    MyPublicTestStatusTransitionEntity? status,
    String? description,
    String? happenedAt,
  }) {
    return MyPublicTestStatusHistoryItemEntity(
      historyId: historyId ?? this.historyId,
      roundId: roundId ?? this.roundId,
      status: status ?? this.status,
      description: description ?? this.description,
      happenedAt: happenedAt ?? this.happenedAt,
    );
  }
}

class MyPublicTestStatusTransitionEntity {
  final String? fromStatus;
  final String? toStatus;

  const MyPublicTestStatusTransitionEntity({
    required this.fromStatus,
    required this.toStatus,
  });

  MyPublicTestStatusTransitionEntity copyWith({
    String? fromStatus,
    String? toStatus,
  }) {
    return MyPublicTestStatusTransitionEntity(
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
    );
  }
}

MyPublicTestStatusType mapStatusToType(String status) {
  final cleanStatus = status.trim();

  switch (cleanStatus) {
    case 'تم حذفه':
      return MyPublicTestStatusType.deleted;

    case 'مبلغ عنه':
      return MyPublicTestStatusType.reported;

    case 'تم الموافقة عليه':
    case 'تمت الموافقة عليه':
      return MyPublicTestStatusType.approved;

    case 'قيد المراجعة':
      return MyPublicTestStatusType.underReview;

    case 'يحتاج تعديل':
      return MyPublicTestStatusType.needsModification;

    case 'مسودة':
    case 'جديد':
      return MyPublicTestStatusType.draft;

    default:
      return MyPublicTestStatusType.unknown;
  }
}
