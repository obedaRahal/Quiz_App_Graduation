// import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_params.dart';

// class CreateManualTestRequestModel {
//   final String title;
//   final String description;
//   final String testType;
//   final String difficultyLevel;
//   final int? durationSeconds;
//   final int? passMarkPercentage;
//   final String language;
//   final num? price;
//   final String targetLevel;
//   final List<int> interestIds;
//   final List<CreateManualTestQuestionRequestModel> questions;

//   const CreateManualTestRequestModel({
//     required this.title,
//     required this.description,
//     required this.testType,
//     required this.difficultyLevel,
//     required this.durationSeconds,
//     required this.passMarkPercentage,
//     required this.language,
//     required this.price,
//     required this.targetLevel,
//     required this.interestIds,
//     required this.questions,
//   });

//   factory CreateManualTestRequestModel.fromParams(
//     CreateManualTestParams params,
//   ) {
//     return CreateManualTestRequestModel(
//       title: params.title,
//       description: params.description,
//       testType: params.testType,
//       difficultyLevel: params.difficultyLevel,
//       durationSeconds: params.durationSeconds,
//       passMarkPercentage: params.passMarkPercentage,
//       language: params.language,
//       price: params.price,
//       targetLevel: params.targetLevel,
//       interestIds: params.interestIds,
//       questions: params.questions
//           .map(CreateManualTestQuestionRequestModel.fromParams)
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final json = <String, dynamic>{
//       'title': title,
//       'description': description,
//       'test_type': testType,
//       'difficulty_level': difficultyLevel,
//       'language': language,
//       'target_level': targetLevel,
//       'interest_ids': interestIds,
//       'questions': questions.map((question) => question.toJson()).toList(),
//     };

//     if (durationSeconds != null) {
//       json['duration_seconds'] = durationSeconds;
//     }

//     if (passMarkPercentage != null) {
//       json['pass_mark_percentage'] = passMarkPercentage;
//     }

//     if (price != null) {
//       json['price'] = price;
//     }

//     return json;
//   }
// }

// class CreateManualTestQuestionRequestModel {
//   final String questionText;
//   final String? hintText;
//   final bool isPreview;
//   final List<CreateManualTestOptionRequestModel> options;

//   const CreateManualTestQuestionRequestModel({
//     required this.questionText,
//     required this.hintText,
//     required this.isPreview,
//     required this.options,
//   });

//   factory CreateManualTestQuestionRequestModel.fromParams(
//     CreateManualTestQuestionParams params,
//   ) {
//     return CreateManualTestQuestionRequestModel(
//       questionText: params.questionText,
//       hintText: params.hintText,
//       isPreview: params.isPreview,
//       options: params.options
//           .map(CreateManualTestOptionRequestModel.fromParams)
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final json = <String, dynamic>{
//       'question_text': questionText,
//       'is_preview': isPreview,
//       'options': options.map((option) => option.toJson()).toList(),
//     };

//     if (hintText != null && hintText!.trim().isNotEmpty) {
//       json['hint_text'] = hintText;
//     }

//     return json;
//   }
// }

// class CreateManualTestOptionRequestModel {
//   final String optionText;
//   final bool isCorrect;

//   const CreateManualTestOptionRequestModel({
//     required this.optionText,
//     required this.isCorrect,
//   });

//   factory CreateManualTestOptionRequestModel.fromParams(
//     CreateManualTestOptionParams params,
//   ) {
//     return CreateManualTestOptionRequestModel(
//       optionText: params.optionText,
//       isCorrect: params.isCorrect,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'option_text': optionText,
//       'is_correct': isCorrect,
//     };
//   }
// }
import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_params.dart';

class CreateManualTestRequestModel {
  final String title;
  final String description;
  final String testType;
  final String difficultyLevel;
  final int? durationSeconds;
  final int? passMarkPercentage;
  final String language;
  final num? price;
  final String targetLevel;
  final List<int> interestIds;
  final List<CreateManualTestQuestionRequestModel> questions;

  const CreateManualTestRequestModel({
    required this.title,
    required this.description,
    required this.testType,
    required this.difficultyLevel,
    required this.durationSeconds,
    required this.passMarkPercentage,
    required this.language,
    required this.price,
    required this.targetLevel,
    required this.interestIds,
    required this.questions,
  });

  factory CreateManualTestRequestModel.fromParams(
    CreateManualTestParams params,
  ) {
    return CreateManualTestRequestModel(
      title: params.title,
      description: params.description,
      testType: params.testType,
      difficultyLevel: params.difficultyLevel,
      durationSeconds: params.durationSeconds,
      passMarkPercentage: params.passMarkPercentage,
      language: params.language,
      price: params.price,
      targetLevel: params.targetLevel,
      interestIds: params.interestIds,
      questions: params.questions
          .map(CreateManualTestQuestionRequestModel.fromParams)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final isPublicTest = testType == 'عام';

    final json = <String, dynamic>{
      'title': title,
      'description': description,
      'test_type': testType,
      'difficulty_level': difficultyLevel,
      'language': language,
      'target_level': targetLevel,
      'interest_ids': interestIds,
      'questions': questions
          .map(
            (question) => question.toJson(
              includePreviewKey: isPublicTest,
            ),
          )
          .toList(),
    };

    /// اختياري في العام والخاص
    if (durationSeconds != null) {
      json['duration_seconds'] = durationSeconds;
    }

    /// اختياري في العام والخاص
    if (passMarkPercentage != null) {
      json['pass_mark_percentage'] = passMarkPercentage;
    }

    /// مهم:
    /// price لا يرسل أبداً إذا الاختبار خاص.
    /// إذا الاختبار عام والسعر null لا نرسله، فيبقى مجاني.
    if (isPublicTest && price != null) {
      json['price'] = price;
    }

    return json;
  }
}

class CreateManualTestQuestionRequestModel {
  final String questionText;
  final String? hintText;
  final bool isPreview;
  final List<CreateManualTestOptionRequestModel> options;

  const CreateManualTestQuestionRequestModel({
    required this.questionText,
    required this.hintText,
    required this.isPreview,
    required this.options,
  });

  factory CreateManualTestQuestionRequestModel.fromParams(
    CreateManualTestQuestionParams params,
  ) {
    return CreateManualTestQuestionRequestModel(
      questionText: params.questionText,
      hintText: params.hintText,
      isPreview: params.isPreview,
      options: params.options
          .map(CreateManualTestOptionRequestModel.fromParams)
          .toList(),
    );
  }

  Map<String, dynamic> toJson({
    required bool includePreviewKey,
  }) {
    final json = <String, dynamic>{
      'question_text': questionText,
      'options': options.map((option) => option.toJson()).toList(),
    };

    /// hint_text اختياري.
    /// إذا فاضي لا نرسله.
    if (hintText != null && hintText!.trim().isNotEmpty) {
      json['hint_text'] = hintText!.trim();
    }

    /// مهم:
    /// is_preview يرسل فقط إذا الاختبار عام.
    /// إذا الاختبار خاص لا نرسل المفتاح أصلاً.
    if (includePreviewKey) {
      json['is_preview'] = isPreview;
    }

    return json;
  }
}

class CreateManualTestOptionRequestModel {
  final String optionText;
  final bool isCorrect;

  const CreateManualTestOptionRequestModel({
    required this.optionText,
    required this.isCorrect,
  });

  factory CreateManualTestOptionRequestModel.fromParams(
    CreateManualTestOptionParams params,
  ) {
    return CreateManualTestOptionRequestModel(
      optionText: params.optionText,
      isCorrect: params.isCorrect,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option_text': optionText,
      'is_correct': isCorrect,
    };
  }
}