class EditableTestQuestionsResponseEntity {
  final bool success;
  final String title;
  final EditableTestQuestionsDataEntity data;
  final int statusCode;

  const EditableTestQuestionsResponseEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class EditableTestQuestionsDataEntity {
  final EditableTestContentEntity test;

  const EditableTestQuestionsDataEntity({
    required this.test,
  });
}

class EditableTestContentEntity {
  final int testId;
  final String title;
  final int questionCount;
  final int? durationSeconds;
  final int? passMarkPercentage;
  final List<EditableQuestionEntity> questions;

  const EditableTestContentEntity({
    required this.testId,
    required this.title,
    required this.questionCount,
    required this.durationSeconds,
    required this.passMarkPercentage,
    required this.questions,
  });
}

class EditableQuestionEntity {
  final int id;
  final int position;
  final String questionText;
  final String? hintText;
  final List<EditableQuestionOptionEntity> options;

  const EditableQuestionEntity({
    required this.id,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.options,
  });
}

class EditableQuestionOptionEntity {
  final int id;
  final int position;
  final String optionText;
  final bool isCorrect;

  const EditableQuestionOptionEntity({
    required this.id,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });
}