class LibraryFeaturedEntity {
  final int id;
  final String urlContent;
  final List<String> interests;
  final int likeCount;
  final int bookmarksCount;
  final int downloadCount;
  final String publishedAt;

  const LibraryFeaturedEntity({
    required this.id,
    required this.urlContent,
    required this.interests,
    required this.likeCount,
    required this.bookmarksCount,
    required this.downloadCount,
    required this.publishedAt,
  });
}