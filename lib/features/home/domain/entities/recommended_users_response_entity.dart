class RecommendedUsersResponseEntity {
  final bool success;
  final String title;
  final List<RecommendedUserEntity> users;
  final int statusCode;

  const RecommendedUsersResponseEntity({
    required this.success,
    required this.title,
    required this.users,
    required this.statusCode,
  });
}

class RecommendedUserEntity {
  final int id;
  final String name;
  final String avatarUrl;
  final int publishedTestsCount;
  final double averageTestRating;

  const RecommendedUserEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.publishedTestsCount,
    required this.averageTestRating,
  });
}