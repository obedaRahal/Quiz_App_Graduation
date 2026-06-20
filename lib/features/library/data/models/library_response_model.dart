import '../../domain/entities/library_response_entity.dart';
import 'library_featured_model.dart';
import 'library_material_model.dart';
import 'library_meta_model.dart';

class LibraryResponseModel extends LibraryResponseEntity {
  const LibraryResponseModel({
    required super.success,
    required super.title,
    required super.tab,
    required super.featured,
    required super.materials,
    required super.meta,
    required super.statusCode,
  });

  factory LibraryResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return LibraryResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      tab: data['tab'] ?? '',
      featured: (data['featured'] as List? ?? [])
          .map((e) => LibraryFeaturedModel.fromJson(e))
          .toList(),
      materials: (data['materials'] as List? ?? [])
          .map((e) => LibraryMaterialModel.fromJson(e))
          .toList(),
      meta: LibraryMetaModel.fromJson(data['meta'] ?? {}),
      statusCode: json['status_code'] ?? 0,
    );
  }
}