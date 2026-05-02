class RecommendedInterestsResponseEntity {
  final bool success;
  final String title;
  final List<RecommendedInterestEntity> interests;
  final int statusCode;

  const RecommendedInterestsResponseEntity({
    required this.success,
    required this.title,
    required this.interests,
    required this.statusCode,
  });
}

class RecommendedInterestEntity {
  final int id;
  final String name;
  final String iconSvg;
  final int testsCount;

  const RecommendedInterestEntity({
    required this.id,
    required this.name,
    required this.iconSvg,
    required this.testsCount,
  });
}