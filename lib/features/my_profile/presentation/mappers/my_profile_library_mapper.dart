// lib/features/my_profile/presentation/mappers/my_profile_library_mapper.dart

import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';

extension MyProfileLibraryItemMapper on MyProfileLibraryItemEntity {
  OtherProfileContentItemEntity toOtherProfileContentEntity() {
    return OtherProfileContentItemEntity(
      id: id,
      urlContent: urlContent,
      title: title,
      description: description,
      type: type,
      interests: interests,
      likeCount: likeCount,
      publishedAt: publishedAt,
      viewerHasBookmarked: viewerHasBookmarked,
    );
  }
}