import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_tests_entity.dart';

class OtherProfileFolderDetailsEntity {
  final bool success;
  final String title;
  final OtherProfileFolderDetailsDataEntity data;
  final int statusCode;

  const OtherProfileFolderDetailsEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class OtherProfileFolderDetailsDataEntity {
  final OtherProfileFolderDetailsInfoEntity folder;
  final List<OtherProfileTestItemEntity> items;

  const OtherProfileFolderDetailsDataEntity({
    required this.folder,
    required this.items,
  });
}

class OtherProfileFolderDetailsInfoEntity {
  final int id;
  final String name;
  final int testsCount;
  final String publishedAt;
  final bool viewerHasBookmarked;

  const OtherProfileFolderDetailsInfoEntity({
    required this.id,
    required this.name,
    required this.testsCount,
    required this.publishedAt,
    required this.viewerHasBookmarked,
  });

  OtherProfileFolderDetailsInfoEntity copyWith({
    int? id,
    String? name,
    int? testsCount,
    String? publishedAt,
    bool? viewerHasBookmarked,
  }) {
    return OtherProfileFolderDetailsInfoEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      testsCount: testsCount ?? this.testsCount,
      publishedAt: publishedAt ?? this.publishedAt,
      viewerHasBookmarked:
          viewerHasBookmarked ?? this.viewerHasBookmarked,
    );
  }
}