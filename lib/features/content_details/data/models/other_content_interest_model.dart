import '../../domain/entities/other_content_interest_entity.dart';

class OtherContentInterestModel extends OtherContentInterestEntity {
  const OtherContentInterestModel({
    required super.id,
    required super.name,
  });

  factory OtherContentInterestModel.fromJson(Map<String, dynamic> json) {
    return OtherContentInterestModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}