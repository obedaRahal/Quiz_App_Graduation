class OtherProfileTestsResponseEntity {
  final bool success;
  final String message;
  final List<OtherProfileTestItemEntity> data;
  final OtherProfileTestsMetaEntity meta;
  final int statusCode;

  const OtherProfileTestsResponseEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });
}

class OtherProfileTestItemEntity {
  final int id;
  final String title;
  final String description;
  final List<String> interests;
  final String targetLevel;
  final String difficultyLevel;
  final double averageRating;
  final String price;
  final String publishedAt;
  final int questionCount;

  const OtherProfileTestItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.targetLevel,
    required this.difficultyLevel,
    required this.averageRating,
    required this.price,
    required this.publishedAt,
    required this.questionCount,
  });
}

class OtherProfileTestsMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const OtherProfileTestsMetaEntity({
    required this.perPage,
    this.nextCursor,
    this.prevCursor,
    required this.hasMorePages,
  });
}