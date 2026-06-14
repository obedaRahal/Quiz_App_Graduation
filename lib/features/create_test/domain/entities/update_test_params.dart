class UpdateTestParams {
  final int testId;
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
  final List<UpdateTestQuestionParams> questions;

  const UpdateTestParams({
    required this.testId,
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
}

class UpdateTestQuestionParams {
  final int? id;
  final int position;
  final String questionText;
  final String? hintText;
  final bool isPreview;
  final List<UpdateTestOptionParams> options;

  const UpdateTestQuestionParams({
    required this.id,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.isPreview,
    required this.options,
  });
}

class UpdateTestOptionParams {
  final int? id;
  final int position;
  final String optionText;
  final bool isCorrect;

  const UpdateTestOptionParams({
    required this.id,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });
}