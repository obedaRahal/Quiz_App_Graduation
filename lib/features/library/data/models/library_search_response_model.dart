import '../../domain/entities/library_search_response_entity.dart';
import 'library_material_model.dart';
import 'library_meta_model.dart';

class LibrarySearchResponseModel extends LibrarySearchResponseEntity {
  const LibrarySearchResponseModel({
    required super.success,
    required super.title,
    required super.query,
    required super.mode,
    required super.materials,
    required super.meta,
    required super.statusCode,
  });

  factory LibrarySearchResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return LibrarySearchResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      query: data['query'] ?? '',
      mode: data['mode'] ?? '',
      materials: (data['materials'] as List? ?? [])
          .map((e) => LibraryMaterialModel.fromJson(e))
          .toList(),
      meta: LibraryMetaModel.fromJson(data['meta'] ?? {}),
      statusCode: json['status_code'] ?? 0,
    );
  }
}