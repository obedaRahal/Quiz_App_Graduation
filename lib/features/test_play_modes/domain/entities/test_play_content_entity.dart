class TestPlayContentEntity {
  final bool success;
  final String title;
  final TestPlayDataEntity data;
  final int statusCode;

  const TestPlayContentEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class TestPlayDataEntity {
  final TestPlayInfoEntity test;
  final TestPlayViewerEntity viewer;

  const TestPlayDataEntity({required this.test, required this.viewer});
}

class TestPlayInfoEntity {
  final int testId;
  final String title;
  final int questionCount;
  final int? durationSeconds;
  final int passMarkPercentage;
  final List<TestPlayQuestionEntity> questions;

  const TestPlayInfoEntity({
    required this.testId,
    required this.title,
    required this.questionCount,
    required this.durationSeconds,
    required this.passMarkPercentage,
    required this.questions,
  });
}

class TestPlayQuestionEntity {
  final int questionId;
  final int position;
  final String questionText;
  final String? hintText;
  final List<TestPlayOptionEntity> options;

  const TestPlayQuestionEntity({
    required this.questionId,
    required this.position,
    required this.questionText,
    required this.hintText,
    required this.options,
  });

  TestPlayOptionEntity? get correctOption {
    try {
      return options.firstWhere((option) => option.isCorrect);
    } catch (_) {
      return null;
    }
  }
}

class TestPlayOptionEntity {
  final int optionId;
  final int position;
  final String optionText;
  final bool isCorrect;

  const TestPlayOptionEntity({
    required this.optionId,
    required this.position,
    required this.optionText,
    required this.isCorrect,
  });
}

class TestPlayViewerEntity {
  final int userId;
  final String name;
  final String? avatarUrl;

  const TestPlayViewerEntity({
    required this.userId,
    required this.name,
    required this.avatarUrl,
  });
}
