import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';

class TestPlayContentModel {
  final bool success;
  final String title;
  final TestPlayDataModel data;
  final int statusCode;

  const TestPlayContentModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory TestPlayContentModel.fromJson(Map<String, dynamic> json) {
    return TestPlayContentModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: TestPlayDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code']),
    );
  }

  TestPlayContentEntity toEntity() {
    return TestPlayContentEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class TestPlayDataModel {
  final TestPlayInfoModel test;
  final TestPlayViewerModel viewer;

  const TestPlayDataModel({
    required this.test,
    required this.viewer,
  });

  factory TestPlayDataModel.fromJson(Map<String, dynamic> json) {
    return TestPlayDataModel(
      test: TestPlayInfoModel.fromJson(
        (json['test'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      viewer: TestPlayViewerModel.fromJson(
        (json['viewer'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  TestPlayDataEntity toEntity() {
    return TestPlayDataEntity(
      test: test.toEntity(),
      viewer: viewer.toEntity(),
    );
  }
}

class TestPlayInfoModel {
  final int testId;
  final String title;
  final int questionCount;
  final int? durationSeconds;
  final int? passMarkPercentage;
  final List<TestPlayQuestionModel> questions;

  const TestPlayInfoModel({
    required this.testId,
    required this.title,
    required this.questionCount,
    required this.durationSeconds,
    required this.passMarkPercentage,
    required this.questions,
  });

  factory TestPlayInfoModel.fromJson(Map<String, dynamic> json) {
    return TestPlayInfoModel(
      testId: _asInt(json['test_id']),
      title: json['title']?.toString() ?? '',
      questionCount: _asInt(json['question_count']),
      durationSeconds: _asNullableInt(json['duration_seconds']),
      passMarkPercentage: _asNullableInt(json['pass_mark_percentage']),
      questions: _asList(json['questions'])
          .map((item) => TestPlayQuestionModel.fromJson(item))
          .toList(),
    );
  }

  TestPlayInfoEntity toEntity() {
    return TestPlayInfoEntity(
      testId: testId,
      title: title,
      questionCount: questionCount,
      durationSeconds: durationSeconds,
      passMarkPercentage: passMarkPercentage ?? 0,
      questions: questions.map((question) => question.toEntity()).toList(),
    );
  }
}

class TestPlayQuestionModel {
  final int questionId;
  final int position;
  final String questionText;
  final String? hintText;
  final List<TestPlayOptionModel> options;

  const TestPlayQuestionModel({
    required this.questionId,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.options,
  });

  factory TestPlayQuestionModel.fromJson(Map<String, dynamic> json) {
    return TestPlayQuestionModel(
      questionId: _asInt(json['question_id']),
      position: _asInt(json['position']),
      questionText: json['question_text']?.toString() ?? '',
      hintText: _asNullableString(json['hint_text']),
      options: _asList(json['options'])
          .map((item) => TestPlayOptionModel.fromJson(item))
          .toList(),
    );
  }

  TestPlayQuestionEntity toEntity() {
    return TestPlayQuestionEntity(
      questionId: questionId,
      position: position,
      questionText: questionText,
      hintText: hintText,
      options: options.map((option) => option.toEntity()).toList(),
    );
  }
}

class TestPlayOptionModel {
  final int optionId;
  final int position;
  final String optionText;
  final bool isCorrect;

  const TestPlayOptionModel({
    required this.optionId,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });

  factory TestPlayOptionModel.fromJson(Map<String, dynamic> json) {
    return TestPlayOptionModel(
      optionId: _asInt(json['option_id']),
      position: _asInt(json['position']),
      optionText: json['option_text']?.toString() ?? '',
      isCorrect: _asBool(json['is_correct']),
    );
  }

  TestPlayOptionEntity toEntity() {
    return TestPlayOptionEntity(
      optionId: optionId,
      position: position,
      optionText: optionText,
      isCorrect: isCorrect,
    );
  }
}

class TestPlayViewerModel {
  final int userId;
  final String name;
  final String? avatarUrl;

  const TestPlayViewerModel({
    required this.userId,
    required this.name,
    required this.avatarUrl,
  });

  factory TestPlayViewerModel.fromJson(Map<String, dynamic> json) {
    return TestPlayViewerModel(
      userId: _asInt(json['user_id']),
      name: json['name']?.toString() ?? '',
      avatarUrl: _asNullableString(json['avatar_url']),
    );
  }

  TestPlayViewerEntity toEntity() {
    return TestPlayViewerEntity(
      userId: userId,
      name: name,
      avatarUrl: avatarUrl,
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

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty) return null;
  if (text.toLowerCase() == 'null') return null;

  return text;
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}