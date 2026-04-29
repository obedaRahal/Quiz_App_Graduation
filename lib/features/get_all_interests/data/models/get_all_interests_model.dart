class InterestCategoryUiModel {
  final int id;
  final String title;
  final List<InterestUiModel> interests;

  const InterestCategoryUiModel({
    required this.id,
    required this.title,
    required this.interests,
  });
}

class InterestUiModel {
  final int id;
  final String name;
  final String iconSvg;
  final String iconColor;

  const InterestUiModel({
    required this.id,
    required this.name,
    required this.iconSvg,
    required this.iconColor,
  });
}