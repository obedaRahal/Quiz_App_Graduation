class MyProfileFolderContentEntity {
  final bool success;
  final String title;
  final List<MyProfileFolderContentTestEntity> data;
  final int statusCode;

  const MyProfileFolderContentEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class MyProfileFolderContentTestEntity {
  final int id;
  final String title;
  final String description;
  final List<String> interests;
  final String difficultyLevel;
  final int questionCount;
  final double averageRating;
  final double price;
  final String publishedAt;
  final String testType;

  const MyProfileFolderContentTestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.difficultyLevel,
    required this.questionCount,
    required this.averageRating,
    required this.price,
    required this.publishedAt,
    required this.testType,
  });
}