import 'library_material_entity.dart';
import 'library_meta_entity.dart';

class LibrarySearchResponseEntity {
  final bool success;
  final String title;
  final String query;
  final String mode;
  final List<LibraryMaterialEntity> materials;
  final LibraryMetaEntity meta;
  final int statusCode;

  const LibrarySearchResponseEntity({
    required this.success,
    required this.title,
    required this.query,
    required this.mode,
    required this.materials,
    required this.meta,
    required this.statusCode,
  });
}