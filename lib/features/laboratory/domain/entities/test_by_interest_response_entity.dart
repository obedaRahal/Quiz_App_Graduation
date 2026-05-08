class TestsByInterestResponseEntity {
  final bool success;
  final String message;
  final List<TestByInterestEntity> tests;
  final TestsByInterestMetaEntity meta;
  final int statusCode;

  const TestsByInterestResponseEntity({
    required this.success,
    required this.message,
    required this.tests,
    required this.meta,
    required this.statusCode,
  });
}

class TestByInterestEntity {
  final int id;
  final String title;
  final String description;
  final List<TestInterestEntity> interests;
  final int questionCount;
  final String difficultyLevel;
  final num price;
  final double averageRating;
  final String publishedAgo;

  const TestByInterestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.questionCount,
    required this.difficultyLevel,
    required this.price,
    required this.averageRating,
    required this.publishedAgo,
  });
}

class TestInterestEntity {
  final int id;
  final String name;

  const TestInterestEntity({
    required this.id,
    required this.name,
  });
}

class TestsByInterestMetaEntity {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const TestsByInterestMetaEntity({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });
}