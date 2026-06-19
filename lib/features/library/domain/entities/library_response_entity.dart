import 'library_featured_entity.dart';
import 'library_material_entity.dart';
import 'library_meta_entity.dart';

class LibraryResponseEntity {
  final bool success;
  final String title;
  final String tab;
  final List<LibraryFeaturedEntity> featured;
  final List<LibraryMaterialEntity> materials;
  final LibraryMetaEntity meta;
  final int statusCode;

  const LibraryResponseEntity({
    required this.success,
    required this.title,
    required this.tab,
    required this.featured,
    required this.materials,
    required this.meta,
    required this.statusCode,
  });
}