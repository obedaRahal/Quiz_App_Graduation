class ScientificClassificationsResponseEntity {
  final bool success;
  final String title;
  final List<ScientificClassificationGroupEntity> groups;
  final int statusCode;

  const ScientificClassificationsResponseEntity({
    required this.success,
    required this.title,
    required this.groups,
    required this.statusCode,
  });
}

class ScientificClassificationGroupEntity {
  final int id;
  final String title;
  final List<ScientificInterestEntity> interests;

  const ScientificClassificationGroupEntity({
    required this.id,
    required this.title,
    required this.interests,
  });
}

class ScientificInterestEntity {
  final int id;
  final String name;
  final String iconSvg;
  final String iconColor;

  const ScientificInterestEntity({
    required this.id,
    required this.name,
    required this.iconSvg,
    required this.iconColor,
  });
}