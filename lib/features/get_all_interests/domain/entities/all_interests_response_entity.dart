class AllInterestsResponseEntity {
  final bool success;
  final String title;
  final List<InterestCategoryEntity> categories;
  final int statusCode;

  const AllInterestsResponseEntity({
    required this.success,
    required this.title,
    required this.categories,
    required this.statusCode,
  });
}

class InterestCategoryEntity {
  final int id;
  final String title;
  final List<InterestItemEntity> interests;

  const InterestCategoryEntity({
    required this.id,
    required this.title,
    required this.interests,
  });
}

class InterestItemEntity {
  final int id;
  final String name;
  final String iconSvg;
  final String iconColor;

  const InterestItemEntity({
    required this.id,
    required this.name,
    required this.iconSvg,
    required this.iconColor,
  });
}