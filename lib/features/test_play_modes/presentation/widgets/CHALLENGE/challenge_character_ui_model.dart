class ChallengeCharacterUiModel {
  final int id;
  final String name;
  final String subtitle;
  final String imagePath;
  final int accuracyPercentage;
  final int minReactionSeconds;
  final int maxReactionSeconds;

  const ChallengeCharacterUiModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imagePath,
    required this.accuracyPercentage,
    required this.minReactionSeconds,
    required this.maxReactionSeconds,
  });
}