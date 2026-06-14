import 'package:quiz_app_grad/features/create_test/domain/entities/editable_test_questions_entity.dart';

class EditableTestQuestionsResponseModel {
  final bool success;
  final String title;
  final EditableTestQuestionsDataModel data;
  final int statusCode;

  const EditableTestQuestionsResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory EditableTestQuestionsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EditableTestQuestionsResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: EditableTestQuestionsDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code']),
    );
  }

  EditableTestQuestionsResponseEntity toEntity() {
    return EditableTestQuestionsResponseEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class EditableTestQuestionsDataModel {
  final EditableTestContentModel test;

  const EditableTestQuestionsDataModel({
    required this.test,
  });

  factory EditableTestQuestionsDataModel.fromJson(Map<String, dynamic> json) {
    return EditableTestQuestionsDataModel(
      test: EditableTestContentModel.fromJson(
        (json['test'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  EditableTestQuestionsDataEntity toEntity() {
    return EditableTestQuestionsDataEntity(
      test: test.toEntity(),
    );
  }
}

class EditableTestContentModel {
  final int testId;
  final String title;
  final int questionCount;
  final int? durationSeconds;
  final int? passMarkPercentage;
  final List<EditableQuestionModel> questions;

  const EditableTestContentModel({
    required this.testId,
    required this.title,
    required this.questionCount,
    required this.durationSeconds,
    required this.passMarkPercentage,
    required this.questions,
  });

  factory EditableTestContentModel.fromJson(Map<String, dynamic> json) {
    final questions = _asList(json['questions'])
      ..sort((a, b) => _asInt(a['position']).compareTo(_asInt(b['position'])));

    return EditableTestContentModel(
      testId: _asInt(json['test_id']),
      title: json['title']?.toString() ?? '',
      questionCount: _asInt(json['question_count']),
      durationSeconds: _asNullableInt(json['duration_seconds']),
      passMarkPercentage: _asNullableInt(json['pass_mark_percentage']),
      questions: questions
          .map((item) => EditableQuestionModel.fromJson(item))
          .toList(),
    );
  }

  EditableTestContentEntity toEntity() {
    return EditableTestContentEntity(
      testId: testId,
      title: title,
      questionCount: questionCount,
      durationSeconds: durationSeconds,
      passMarkPercentage: passMarkPercentage,
      questions: questions.map((item) => item.toEntity()).toList(),
    );
  }
}

class EditableQuestionModel {
  final int id;
  final int position;
  final String questionText;
  final String? hintText;
  final List<EditableQuestionOptionModel> options;

  const EditableQuestionModel({
    required this.id,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.options,
  });

  factory EditableQuestionModel.fromJson(Map<String, dynamic> json) {
    final options = _asList(json['options'])
      ..sort((a, b) => _asInt(a['position']).compareTo(_asInt(b['position'])));

    return EditableQuestionModel(
      id: _asInt(json['question_id']),
      position: _asInt(json['position']),
      questionText: json['question_text']?.toString() ?? '',
      hintText: _asNullableString(json['hint_text']),
      options: options
          .map((item) => EditableQuestionOptionModel.fromJson(item))
          .toList(),
    );
  }

  EditableQuestionEntity toEntity() {
    return EditableQuestionEntity(
      id: id,
      position: position,
      questionText: questionText,
      hintText: hintText,
      options: options.map((item) => item.toEntity()).toList(),
    );
  }
}

class EditableQuestionOptionModel {
  final int id;
  final int position;
  final String optionText;
  final bool isCorrect;

  const EditableQuestionOptionModel({
    required this.id,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });

  factory EditableQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return EditableQuestionOptionModel(
      id: _asInt(json['option_id']),
      position: _asInt(json['position']),
      optionText: json['option_text']?.toString() ?? '',
      isCorrect: json['is_correct'] == true,
    );
  }

  EditableQuestionOptionEntity toEntity() {
    return EditableQuestionOptionEntity(
      id: id,
      position: position,
      optionText: optionText,
      isCorrect: isCorrect,
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

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();
  if (text.isEmpty || text == 'null') return null;

  return text;
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return const [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}