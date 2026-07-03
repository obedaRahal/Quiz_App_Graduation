import 'package:quiz_app_grad/features/content_details/domain/entities/other_content_details_entity.dart';

import '../widget/content_details_demo_data.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_entity.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_demo_data.dart';

extension MyContentDetailsMapper on MyContentDetailsEntity {
  ContentDetailsUiData toUi() {
    return ContentDetailsUiData(
      id: basicInfo.id,
      title: basicInfo.title,
      description: basicInfo.description,
      interests: basicInfo.interests,
      targetLevel: basicInfo.targetLevel,
      contentKind: basicInfo.contentKind,
      assetCount: basicInfo.assetCount,
      likeCount: 0,
      bookmarksCount: 0,
      downloadCount: 0,
      publishedAt: basicInfo.publishedAt,
      assets: basicInfo.assets
          .map(
            (asset) => ContentAssetUiData(
              id: asset.id,
              url: asset.url,
              position: asset.position,
            ),
          )
          .toList(),
      publisher: null,
      isOwner: true,
      isPublic: basicInfo.visibilityType.trim() == 'محتوى عام',
    );
  }
}

extension OtherContentDetailsMapper on OtherContentDetailsEntity {
  ContentDetailsUiData toUi() {
    return ContentDetailsUiData(
      id: basicInfo.id,

      title: basicInfo.title,

      description: basicInfo.description,

      interests: basicInfo.interests.map((e) => e.name).toList(),

      targetLevel: basicInfo.targetLevel,

      contentKind: basicInfo.contentKind,

      assetCount: basicInfo.assetCount,

      likeCount: basicInfo.likeCount,

      bookmarksCount: basicInfo.bookmarksCount,

      downloadCount: basicInfo.downloadCount,

      publishedAt: basicInfo.publishedAt ?? '',

      assets: basicInfo.assets
          .map(
            (e) =>
                ContentAssetUiData(id: e.id, url: e.url, position: e.position),
          )
          .toList(),

      publisher: ContentPublisherUiData(
        id: publisher.id,

        name: publisher.name,

        avatarUrl: publisher.avatarUrl,

        followersCount: publisher.followersCount,

        followingCount: publisher.followingCount,

        publishedTestsCount: publisher.publishedTestsCount,

        isVerified: viewerState.creatorIsAcademicallyVerified,
      ),

      viewerHasLiked: viewerState.viewerHasLiked,

      viewerHasBookmarked: viewerState.viewerHasBookmarked,

      viewerIsFollowingCreator: viewerState.viewerIsFollowingCreator,
    );
  }
}
