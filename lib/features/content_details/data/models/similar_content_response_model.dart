import '../../domain/entities/similar_content_response_entity.dart';
import 'similar_content_material_model.dart';
import 'similar_content_meta_model.dart';

class SimilarContentResponseModel extends SimilarContentResponseEntity {
  const SimilarContentResponseModel({
    required super.materials,
    required super.meta,
  });

  factory SimilarContentResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return SimilarContentResponseModel(
      materials: (data['materials'] as List?)
              ?.map(
                (e) => SimilarContentMaterialModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      meta: SimilarContentMetaModel.fromJson(
        data['meta'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}