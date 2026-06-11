class AiGenerationDailyLimitEntity {
  final bool success;
  final String title;
  final AiGenerationDailyLimitDataEntity data;
  final int statusCode;

  const AiGenerationDailyLimitEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class AiGenerationDailyLimitDataEntity {
  final int usedAttempts;
  final int dailyLimit;
  final int remainingAttempts;
  final String attemptsLabel;
  final bool hasReachedDailyLimit;

  const AiGenerationDailyLimitDataEntity({
    required this.usedAttempts,
    required this.dailyLimit,
    required this.remainingAttempts,
    required this.attemptsLabel,
    required this.hasReachedDailyLimit,
  });
}