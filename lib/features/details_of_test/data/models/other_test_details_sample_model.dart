import '../../domain/entities/other_test_details_sample_entity.dart';

class OtherTestDetailsSampleModel {
  final bool success;
  final String title;
  final List<SampleQuestionModel> questions;
  final int statusCode;

  const OtherTestDetailsSampleModel({
    required this.success,
    required this.title,
    required this.questions,
    required this.statusCode,
  });

  factory OtherTestDetailsSampleModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as List<dynamic>? ?? [];

    return OtherTestDetailsSampleModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      questions: dataJson
          .map(
            (item) => SampleQuestionModel.fromJson(
              item as Map<String, dynamic>? ?? {},
            ),
          )
          .toList(),
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  OtherTestDetailsSampleEntity toEntity() {
    return OtherTestDetailsSampleEntity(
      success: success,
      title: title,
      questions: questions.map((item) => item.toEntity()).toList(),
      statusCode: statusCode,
    );
  }
}

class SampleQuestionModel {
  final int id;
  final int position;
  final String questionText;
  final String? hintText;
  final List<SampleQuestionOptionModel> options;

  const SampleQuestionModel({
    required this.id,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.options,
  });

  factory SampleQuestionModel.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['test_question_options'] as List<dynamic>? ?? [];

    return SampleQuestionModel(
      id: json['id'] as int? ?? 0,
      position: json['position'] as int? ?? 0,
      questionText: json['question_text']?.toString() ?? '',
      hintText: json['hint_text']?.toString(),
      options: optionsJson
          .map(
            (item) => SampleQuestionOptionModel.fromJson(
              item as Map<String, dynamic>? ?? {},
            ),
          )
          .toList(),
    );
  }

  SampleQuestionEntity toEntity() {
    return SampleQuestionEntity(
      id: id,
      position: position,
      questionText: questionText,
      hintText: hintText,
      options: options.map((item) => item.toEntity()).toList(),
    );
  }
}

class SampleQuestionOptionModel {
  final int id;
  final int testQuestionId;
  final int position;
  final String optionText;
  final bool isCorrect;

  const SampleQuestionOptionModel({
    required this.id,
    required this.testQuestionId,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });

  factory SampleQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return SampleQuestionOptionModel(
      id: json['id'] as int? ?? 0,
      testQuestionId: json['test_question_id'] as int? ?? 0,
      position: json['position'] as int? ?? 0,
      optionText: json['option_text']?.toString() ?? '',
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }

  SampleQuestionOptionEntity toEntity() {
    return SampleQuestionOptionEntity(
      id: id,
      testQuestionId: testQuestionId,
      position: position,
      optionText: optionText,
      isCorrect: isCorrect,
    );
  }
}