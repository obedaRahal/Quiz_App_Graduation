import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_tests_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';

extension MyProfileBookmarkTestMapper on MyProfileBookmarkTestEntity {
  OtherProfileTestItemEntity toOtherProfileTestItemEntity() {
    return OtherProfileTestItemEntity(
      id: id,
      title: title,
      description: description,
      interests: interests,
      //targetLevel: targetLevel,
      difficultyLevel: difficultyLevel,
      averageRating: averageRating,
      price: price,
      publishedAt: publishedAt,
      questionCount: questionCount,
      // تحتاج تعديل هنا
       targetLevel: ""
    );
  }
}

extension MyProfileBookmarkMaterialMapper on MyProfileBookmarkMaterialEntity {
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

extension MyProfileBookmarkFolderMapper on MyProfileBookmarkFolderEntity {
  OtherProfileFolderItemEntity toOtherProfileFolderEntity() {
    return OtherProfileFolderItemEntity(
      id: id,
      name: name,
      testsCount: testsCount,
      publishedAt: publishedAt,
      scientificInterests: scientificInterests,
      colorCode: colorCode,
      viewerHasBookmarked: viewerHasBookmarked,
    );
  }
}
