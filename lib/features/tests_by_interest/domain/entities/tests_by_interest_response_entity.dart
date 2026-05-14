class TestsByInterestResponseEntity {
  final List<TestByInterestEntity> tests;
  final TestsByInterestMetaEntity meta;

  const TestsByInterestResponseEntity({
    required this.tests,
    required this.meta,
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