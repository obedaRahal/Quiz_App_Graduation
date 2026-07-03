import '../../domain/entities/similar_content_meta_entity.dart';

class SimilarContentMetaModel extends SimilarContentMetaEntity {
  const SimilarContentMetaModel({
    required super.perPage,
    super.nextCursor,
    super.previousCursor,
    required super.hasMorePages,
  });

  factory SimilarContentMetaModel.fromJson(Map<String, dynamic> json) {
    return SimilarContentMetaModel(
      perPage: json['per_page'] ?? 20,
      nextCursor: json['next_cursor'],
      previousCursor: json['previous_cursor'],
      hasMorePages: json['has_more_pages'] ?? false,
    );
  }
}