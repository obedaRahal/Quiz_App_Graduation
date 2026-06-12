class FilterTestsResponseEntity {
  final bool success;
  final String message;
  final List<FilteredTestEntity> tests;
  final FilterTestsMetaEntity meta;
  final int statusCode;

  const FilterTestsResponseEntity({
    required this.success,
    required this.message,
    required this.tests,
    required this.meta,
    required this.statusCode,
  });
}

class FilteredTestEntity {
  final int id;
  final String title;
  final String description;
  final String difficultyLevel;
  final String price;
  final String averageRating;
  final String publishedAt;
  final int questionCount;
  final List<String> interests;

  const FilteredTestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.price,
    required this.averageRating,
    required this.publishedAt,
    required this.questionCount,
    required this.interests,
  });
}

class FilterTestsMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const FilterTestsMetaEntity({
    required this.perPage,
    required this.nextCursor,
    required this.prevCursor,
    required this.hasMorePages,
  });
}