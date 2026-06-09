// class CreateManualTestParams {
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
//   final List<CreateManualTestQuestionParams> questions;

//   const CreateManualTestParams({
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
// }

// class CreateManualTestQuestionParams {
//   final String questionText;
//   final String? hintText;
//   final bool isPreview;
//   final List<CreateManualTestOptionParams> options;

//   const CreateManualTestQuestionParams({
//     required this.questionText,
//     required this.hintText,
//     required this.isPreview,
//     required this.options,
//   });
// }

// class CreateManualTestOptionParams {
//   final String optionText;
//   final bool isCorrect;

//   const CreateManualTestOptionParams({
//     required this.optionText,
//     required this.isCorrect,
//   });
// }
class CreateManualTestParams {
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
  final List<CreateManualTestQuestionParams> questions;

  const CreateManualTestParams({
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

  bool get isPublic => testType == 'عام';
  bool get isPrivate => testType == 'خاص';
}

class CreateManualTestQuestionParams {
  final String questionText;

  /// نفس شرح الإجابة عندك بالواجهة.
  /// حسب الباك اسمه hint_text وهو اختياري.
  final String? hintText;

  /// ترسل فقط إذا كان الاختبار عام.
  /// إذا الاختبار خاص لا نرسل is_preview أصلاً.
  final bool isPreview;

  final List<CreateManualTestOptionParams> options;

  const CreateManualTestQuestionParams({
    required this.questionText,
    required this.hintText,
    required this.isPreview,
    required this.options,
  });
}

class CreateManualTestOptionParams {
  final String optionText;
  final bool isCorrect;

  const CreateManualTestOptionParams({
    required this.optionText,
    required this.isCorrect,
  });
}