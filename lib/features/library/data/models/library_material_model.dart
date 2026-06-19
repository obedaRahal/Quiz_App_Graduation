import '../../domain/entities/library_material_entity.dart';

class LibraryMaterialModel extends LibraryMaterialEntity {
  const LibraryMaterialModel({
    required super.id,
    required super.urlContent,
    required super.title,
    required super.description,
    required super.type,
    required super.interests,
    required super.likeCount,
    required super.publishedAt,
    required super.viewerHasBookmarked,
  });

  factory LibraryMaterialModel.fromJson(Map<String, dynamic> json) {
    return LibraryMaterialModel(
      id: json['id'] ?? 0,
      urlContent: json['url_content'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      interests: List<String>.from(json['interests'] ?? const []),
      likeCount: json['like_count'] ?? 0,
      publishedAt: json['published_at'] ?? '',
      viewerHasBookmarked: json['viewer_has_bookmarked'] ?? false,
    );
  }
}