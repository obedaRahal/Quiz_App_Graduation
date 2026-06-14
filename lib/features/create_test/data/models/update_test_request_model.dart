import 'package:quiz_app_grad/features/create_test/domain/entities/update_test_params.dart';

class UpdateTestRequestModel {
  final String title;
  final String description;
  final int? durationSeconds;
  final int? passMarkPercentage;
  final String testType;
  final String language;
  final String difficultyLevel;
  final String targetLevel;
  final num? price;
  final List<int> interestIds;
  final List<UpdateTestQuestionRequestModel> questions;

  const UpdateTestRequestModel({
    required this.title,
    required this.description,
    required this.durationSeconds,
    required this.passMarkPercentage,
    required this.testType,
    required this.language,
    required this.difficultyLevel,
    required this.targetLevel,
    required this.price,
    required this.interestIds,
    required this.questions,
  });

  factory UpdateTestRequestModel.fromParams(UpdateTestParams params) {
    return UpdateTestRequestModel(
      title: params.title,
      description: params.description,
      durationSeconds: params.durationSeconds,
      passMarkPercentage: params.passMarkPercentage,
      testType: params.testType,
      language: params.language,
      difficultyLevel: params.difficultyLevel,
      targetLevel: params.targetLevel,
      price: params.price,
      interestIds: params.interestIds,
      questions: params.questions
          .map(UpdateTestQuestionRequestModel.fromParams)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'description': description,
      'test_type': testType,
      'language': language,
      'difficulty_level': difficultyLevel,
      'target_level': targetLevel,
      'interest_ids': interestIds,
      // 'interests_ids': interestIds,
      // 'interests': interestIds,
      'questions': questions.map((question) => question.toJson()).toList(),
    };

    if (durationSeconds != null) {
      json['duration_seconds'] = durationSeconds;
    }

    if (passMarkPercentage != null) {
      json['pass_mark_percentage'] = passMarkPercentage;
    }

    /// إذا الاختبار خاص لا نرسل السعر.
    /// إذا عام والسعر null أو 0 فهو مجاني حسب الباك.
    if (testType == 'عام') {
      json['price'] = price;
    }

    return json;
  }
}

class UpdateTestQuestionRequestModel {
  final int? id;
  final int position;
  final String questionText;
  final String? hintText;
  final bool isPreview;
  final List<UpdateTestOptionRequestModel> options;

  const UpdateTestQuestionRequestModel({
    required this.id,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.isPreview,
    required this.options,
  });

  factory UpdateTestQuestionRequestModel.fromParams(
    UpdateTestQuestionParams params,
  ) {
    return UpdateTestQuestionRequestModel(
      id: params.id,
      position: params.position,
      questionText: params.questionText,
      hintText: params.hintText,
      isPreview: params.isPreview,
      options: params.options
          .map(UpdateTestOptionRequestModel.fromParams)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'position': position,
      'question_text': questionText,
      'hint_text': hintText,
      'is_preview': isPreview,
      'options': options.map((option) => option.toJson()).toList(),
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }
}

class UpdateTestOptionRequestModel {
  final int? id;
  final int position;
  final String optionText;
  final bool isCorrect;

  const UpdateTestOptionRequestModel({
    required this.id,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });

  factory UpdateTestOptionRequestModel.fromParams(
    UpdateTestOptionParams params,
  ) {
    return UpdateTestOptionRequestModel(
      id: params.id,
      position: params.position,
      optionText: params.optionText,
      isCorrect: params.isCorrect,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'position': position,
      'option_text': optionText,
      'is_correct': isCorrect,
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }
}
