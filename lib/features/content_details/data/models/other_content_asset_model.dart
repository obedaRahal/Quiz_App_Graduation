import '../../domain/entities/other_content_asset_entity.dart';

class OtherContentAssetModel extends OtherContentAssetEntity {
  const OtherContentAssetModel({
    required super.id,
    required super.url,
    required super.position,
  });

  factory OtherContentAssetModel.fromJson(Map<String, dynamic> json) {
    return OtherContentAssetModel(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      position: json['position'] ?? 0,
    );
  }
}