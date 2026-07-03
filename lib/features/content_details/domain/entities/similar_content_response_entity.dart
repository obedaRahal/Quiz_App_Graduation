import 'similar_content_material_entity.dart';
import 'similar_content_meta_entity.dart';

class SimilarContentResponseEntity {
  final List<SimilarContentMaterialEntity> materials;
  final SimilarContentMetaEntity meta;

  const SimilarContentResponseEntity({
    required this.materials,
    required this.meta,
  });
}