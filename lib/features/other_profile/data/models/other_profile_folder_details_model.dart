import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_tests_model.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folder_details_entity.dart';

class OtherProfileFolderDetailsModel extends OtherProfileFolderDetailsEntity {
  const OtherProfileFolderDetailsModel({
    required super.success,
    required super.title,
    required OtherProfileFolderDetailsDataModel super.data,
    required super.statusCode,
  });

  factory OtherProfileFolderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OtherProfileFolderDetailsModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: OtherProfileFolderDetailsDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code'], fallback: 200),
    );
  }
}

class OtherProfileFolderDetailsDataModel
    extends OtherProfileFolderDetailsDataEntity {
  const OtherProfileFolderDetailsDataModel({
    required OtherProfileFolderDetailsInfoModel super.folder,
    required List<OtherProfileTestItemModel> super.items,
  });

  factory OtherProfileFolderDetailsDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtherProfileFolderDetailsDataModel(
      folder: OtherProfileFolderDetailsInfoModel.fromJson(
        (json['folder'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      items: _asMapList(json['items'])
          .map((item) => OtherProfileTestItemModel.fromJson(item))
          .toList(),
    );
  }
}

class OtherProfileFolderDetailsInfoModel
    extends OtherProfileFolderDetailsInfoEntity {
  const OtherProfileFolderDetailsInfoModel({
    required super.id,
    required super.name,
    required super.testsCount,
    required super.publishedAt,
    required super.viewerHasBookmarked,
  });

  factory OtherProfileFolderDetailsInfoModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtherProfileFolderDetailsInfoModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      testsCount: _asInt(json['tests_count']),
      publishedAt: json['published_at']?.toString() ?? '',
      viewerHasBookmarked: json['viewer_has_bookmarked'] == true,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}