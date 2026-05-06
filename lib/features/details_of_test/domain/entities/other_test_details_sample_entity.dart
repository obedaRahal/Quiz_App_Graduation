class OtherTestDetailsSampleEntity {
  final bool success;
  final String title;
  final List<SampleQuestionEntity> questions;
  final int statusCode;

  const OtherTestDetailsSampleEntity({
    required this.success,
    required this.title,
    required this.questions,
    required this.statusCode,
  });
}

class SampleQuestionEntity {
  final int id;
  final int position;
  final String questionText;
  final String? hintText;
  final List<SampleQuestionOptionEntity> options;

  const SampleQuestionEntity({
    required this.id,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.options,
  });
}

class SampleQuestionOptionEntity {
  final int id;
  final int testQuestionId;
  final int position;
  final String optionText;
  final bool isCorrect;

  const SampleQuestionOptionEntity({
    required this.id,
    required this.testQuestionId,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });
}