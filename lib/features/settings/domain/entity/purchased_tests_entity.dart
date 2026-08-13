class PurchasedTestsEntity {
  final bool success;
  final String title;
  final List<PurchasedTestEntity> tests;
  final int statusCode;

  const PurchasedTestsEntity({
    required this.success,
    required this.title,
    required this.tests,
    required this.statusCode,
  });
}

class PurchasedTestEntity {
  final int id;
  final String title;
  final String description;
  final List<String> interests;
  final String difficultyLevel;
  final double averageRating;
  final String price;
  final String publishedAt;
  final int questionCount;
  final String purchasedAt;

  const PurchasedTestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.difficultyLevel,
    required this.averageRating,
    required this.price,
    required this.publishedAt,
    required this.questionCount,
    required this.purchasedAt,
  });
}
