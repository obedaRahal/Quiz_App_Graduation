import 'dart:convert';

import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';

class StoredAiGenerationTask {
  final int requestId;
  final String sourceType;
  final int questionCount;
  final String level;
  final String language;
  final List<String> fileNames;
  final DateTime createdAt;

  const StoredAiGenerationTask({
    required this.requestId,
    required this.sourceType,
    required this.questionCount,
    required this.level,
    required this.language,
    required this.fileNames,
    required this.createdAt,
  });

  bool get isImages => sourceType.toLowerCase() == 'images';

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'source_type': sourceType,
      'question_count': questionCount,
      'level': level,
      'language': language,
      'file_names': fileNames,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  factory StoredAiGenerationTask.fromJson(Map<String, dynamic> json) {
    final requestId = int.tryParse(json['request_id']?.toString() ?? '') ?? 0;
    final questionCount =
        int.tryParse(json['question_count']?.toString() ?? '') ?? 0;
    final createdAt = DateTime.tryParse(json['created_at']?.toString() ?? '');

    if (requestId <= 0 || questionCount <= 0 || createdAt == null) {
      throw const FormatException('Invalid stored AI generation task');
    }

    return StoredAiGenerationTask(
      requestId: requestId,
      sourceType: json['source_type']?.toString() ?? '',
      questionCount: questionCount,
      level: json['level']?.toString() ?? 'سهل',
      language: json['language']?.toString() ?? 'عربية',
      fileNames: (json['file_names'] as List? ?? const [])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
      createdAt: createdAt.toLocal(),
    );
  }
}

abstract class AiGenerationTaskStorage {
  Future<void> save(StoredAiGenerationTask task);

  StoredAiGenerationTask? read();

  Future<void> clear();
}

class CacheAiGenerationTaskStorage implements AiGenerationTaskStorage {
  static const _storageKey = 'pending_ai_generation_task';

  const CacheAiGenerationTaskStorage();

  @override
  Future<void> save(StoredAiGenerationTask task) async {
    await CacheHelper.saveData(
      key: _storageKey,
      value: jsonEncode(task.toJson()),
    );
  }

  @override
  StoredAiGenerationTask? read() {
    final raw = CacheHelper.getString(key: _storageKey);
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return StoredAiGenerationTask.fromJson(decoded);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    await CacheHelper.removeData(key: _storageKey);
  }
}
