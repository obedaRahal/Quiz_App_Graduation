class MyProfilePickerTestsEntity {
  final bool success;
  final String message;
  final List<MyProfilePickerTestItemEntity> data;
  final MyProfilePickerTestsMetaEntity meta;
  final int statusCode;

  const MyProfilePickerTestsEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });
}

class MyProfilePickerTestItemEntity {
  final int id;
  final String title;
  final String description;
  final List<MyProfilePickerTestInterestEntity> interests;
  final String targetLevel;
  final double averageRating;
  final double price;
  final String publishedAt;
  final int questionCount;

  const MyProfilePickerTestItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.targetLevel,
    required this.averageRating,
    required this.price,
    required this.publishedAt,
    required this.questionCount,
  });

  List<String> get interestNames => interests.map((item) => item.name).toList();
}

class MyProfilePickerTestInterestEntity {
  final int id;
  final String name;

  const MyProfilePickerTestInterestEntity({
    required this.id,
    required this.name,
  });
}

class MyProfilePickerTestsMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const MyProfilePickerTestsMetaEntity({
    required this.perPage,
    required this.nextCursor,
    required this.prevCursor,
    required this.hasMorePages,
  });
}

class MyProfilePickerSearchTestsEntity {
  final bool success;
  final String message;
  final List<MyProfilePickerTestItemEntity> data;
  final MyProfilePickerSearchTestsMetaEntity meta;
  final int statusCode;

  const MyProfilePickerSearchTestsEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });
}

class MyProfilePickerSearchTestsMetaEntity {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const MyProfilePickerSearchTestsMetaEntity({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });

  int get nextPage => currentPage + 1;
}
