import 'package:quiz_app_grad/features/laboratory/domain/entities/ai_generation_daily_limit_entity.dart';

class AiGenerationDailyLimitModel {
  final bool success;
  final String title;
  final AiGenerationDailyLimitDataModel data;
  final int statusCode;

  const AiGenerationDailyLimitModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory AiGenerationDailyLimitModel.fromJson(Map<String, dynamic> json) {
    return AiGenerationDailyLimitModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? AiGenerationDailyLimitDataModel.fromJson(json['data'])
          : AiGenerationDailyLimitDataModel.fromJson(const {}),
      statusCode: int.tryParse((json['status_code'] ?? 0).toString()) ?? 0,
    );
  }

  AiGenerationDailyLimitEntity toEntity() {
    return AiGenerationDailyLimitEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class AiGenerationDailyLimitDataModel {
  final int usedAttempts;
  final int dailyLimit;
  final int remainingAttempts;
  final String attemptsLabel;
  final bool hasReachedDailyLimit;

  const AiGenerationDailyLimitDataModel({
    required this.usedAttempts,
    required this.dailyLimit,
    required this.remainingAttempts,
    required this.attemptsLabel,
    required this.hasReachedDailyLimit,
  });

  factory AiGenerationDailyLimitDataModel.fromJson(Map<String, dynamic> json) {
    return AiGenerationDailyLimitDataModel(
      usedAttempts: int.tryParse((json['used_attempts'] ?? 0).toString()) ?? 0,
      dailyLimit: int.tryParse((json['daily_limit'] ?? 0).toString()) ?? 0,
      remainingAttempts:
          int.tryParse((json['remaining_attempts'] ?? 0).toString()) ?? 0,
      attemptsLabel: json['attempts_label']?.toString() ?? '',
      hasReachedDailyLimit: json['has_reached_daily_limit'] == true,
    );
  }

  AiGenerationDailyLimitDataEntity toEntity() {
    return AiGenerationDailyLimitDataEntity(
      usedAttempts: usedAttempts,
      dailyLimit: dailyLimit,
      remainingAttempts: remainingAttempts,
      attemptsLabel: attemptsLabel,
      hasReachedDailyLimit: hasReachedDailyLimit,
    );
  }
}