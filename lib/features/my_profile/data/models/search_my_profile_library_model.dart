import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_library_model.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';

class SearchMyProfileLibraryModel extends MyProfileLibraryEntity {
  const SearchMyProfileLibraryModel({
    required super.success,
    required super.message,
    required List<MyProfileLibraryItemModel> super.data,
    required MyProfileLibraryMetaModel super.meta,
    required super.statusCode,
  });

  factory SearchMyProfileLibraryModel.fromJson(Map<String, dynamic> json) {
    final dataJson = (json['data'] as Map?)?.cast<String, dynamic>() ?? {};

    return SearchMyProfileLibraryModel(
      success: json['success'] == true,
      message: json['title']?.toString() ?? json['message']?.toString() ?? '',
      data: _asMapList(dataJson['materials'])
          .map((item) => MyProfileLibraryItemModel.fromJson(item))
          .toList(),
      meta: MyProfileLibraryMetaModel.fromJson(
        (dataJson['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();

  if (value is String) {
    final text = value.trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
    return int.tryParse(text) ?? fallback;
  }

  return fallback;
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}