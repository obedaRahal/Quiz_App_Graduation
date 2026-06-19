import '../../domain/entities/library_meta_entity.dart';

class LibraryMetaModel extends LibraryMetaEntity {
  const LibraryMetaModel({
    required super.perPage,
    required super.nextCursor,
    required super.previousCursor,
    required super.hasMorePages,
  });

  factory LibraryMetaModel.fromJson(Map<String, dynamic> json) {
    return LibraryMetaModel(
      perPage: json['per_page'] ?? 20,
      nextCursor: json['next_cursor'],
      previousCursor: json['previous_cursor'],
      hasMorePages: json['has_more_pages'] ?? false,
    );
  }
}