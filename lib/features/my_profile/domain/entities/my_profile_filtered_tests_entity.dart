class MyProfileFilteredTestsEntity {
  final bool success;
  final String message;
  final List<MyProfileFilteredTestItemEntity> data;
  final MyProfileFilteredTestsMetaEntity meta;
  final int statusCode;

  const MyProfileFilteredTestsEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });
}

class MyProfileFilteredTestItemEntity {
  final int id;
  final String title;
  final String description;
  final String difficultyLevel;
  final String price;
  final double averageRating;
  final String publishedAt;
  final int questionCount;
  final List<String> interests;

  const MyProfileFilteredTestItemEntity({
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

class MyProfileFilteredTestsMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const MyProfileFilteredTestsMetaEntity({
    required this.perPage,
    required this.nextCursor,
    required this.prevCursor,
    required this.hasMorePages,
  });
}