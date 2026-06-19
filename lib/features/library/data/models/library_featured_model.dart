import '../../domain/entities/library_featured_entity.dart';

class LibraryFeaturedModel extends LibraryFeaturedEntity {
  const LibraryFeaturedModel({
    required super.id,
    required super.urlContent,
    required super.interests,
    required super.likeCount,
    required super.bookmarksCount,
    required super.downloadCount,
    required super.publishedAt,
  });

  factory LibraryFeaturedModel.fromJson(Map<String, dynamic> json) {
    return LibraryFeaturedModel(
      id: json['id'] ?? 0,
      urlContent: json['url_content'] ?? '',
      interests: List<String>.from(json['interests'] ?? const []),
      likeCount: json['like_count'] ?? 0,
      bookmarksCount: json['bookmarks_count'] ?? 0,
      downloadCount: json['download_count'] ?? 0,
      publishedAt: json['published_at'] ?? '',
    );
  }
}