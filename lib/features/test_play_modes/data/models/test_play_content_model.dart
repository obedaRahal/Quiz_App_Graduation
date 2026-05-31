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
      title: (json['title'] ?? '').toString(),
      data: TestPlayDataModel.fromJson(json['data'] ?? {}),
      statusCode: json['status_code'] ?? 0,
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
      test: TestPlayInfoModel.fromJson(json['test'] ?? {}),
      viewer: TestPlayViewerModel.fromJson(json['viewer'] ?? {}),
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
  final int durationSeconds;
  final int passMarkPercentage;
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
      testId: json['test_id'] ?? 0,
      title: (json['title'] ?? '').toString(),
      questionCount: json['question_count'] ?? 0,
      durationSeconds: json['duration_seconds'] ?? 0,
      passMarkPercentage: json['pass_mark_percentage'] ?? 0,
      questions: ((json['questions'] ?? []) as List)
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
      passMarkPercentage: passMarkPercentage,
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
      questionId: json['question_id'] ?? 0,
      position: json['position'] ?? 0,
      questionText: (json['question_text'] ?? '').toString(),
      hintText: json['hint_text']?.toString(),
      options: ((json['options'] ?? []) as List)
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
      optionId: json['option_id'] ?? 0,
      position: json['position'] ?? 0,
      optionText: (json['option_text'] ?? '').toString(),
      isCorrect: json['is_correct'] == true,
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
      userId: json['user_id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      avatarUrl: json['avatar_url']?.toString(),
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