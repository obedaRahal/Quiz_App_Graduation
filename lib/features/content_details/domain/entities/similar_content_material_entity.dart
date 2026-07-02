class SimilarContentMaterialEntity {
  final int id;
  final String urlContent;
  final String title;
  final String description;
  final String type;
  final List<String> interests;
  final int likeCount;
  final String publishedAt;
  final bool viewerHasBookmarked;

  const SimilarContentMaterialEntity({
    required this.id,
    required this.urlContent,
    required this.title,
    required this.description,
    required this.type,
    required this.interests,
    required this.likeCount,
    required this.publishedAt,
    required this.viewerHasBookmarked,
  });
}