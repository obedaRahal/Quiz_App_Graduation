import '../../domain/entities/similar_content_material_entity.dart';

class SimilarContentMaterialModel extends SimilarContentMaterialEntity {
  const SimilarContentMaterialModel({
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

  factory SimilarContentMaterialModel.fromJson(Map<String, dynamic> json) {
    return SimilarContentMaterialModel(
      id: json['id'] ?? 0,
      urlContent: json['url_content'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      interests: (json['interests'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      likeCount: json['like_count'] ?? 0,
      publishedAt: json['published_at'] ?? '',
      viewerHasBookmarked: json['viewer_has_bookmarked'] ?? false,
    );
  }
}