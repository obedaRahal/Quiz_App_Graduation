import 'package:quiz_app_grad/features/content_details/domain/entities/other_content_details_entity.dart';

import '../widget/content_details_demo_data.dart';

extension OtherContentDetailsMapper
    on OtherContentDetailsEntity {

  ContentDetailsUiData toUi() {

    return ContentDetailsUiData(

      id: basicInfo.id,

      title: basicInfo.title,

      description: basicInfo.description,

      interests: basicInfo.interests
          .map((e) => e.name)
          .toList(),

      targetLevel: basicInfo.targetLevel,

      contentKind: basicInfo.contentKind,

      assetCount: basicInfo.assetCount,

      likeCount: basicInfo.likeCount,

      bookmarksCount: basicInfo.bookmarksCount,

      downloadCount: basicInfo.downloadCount,

      publishedAt: basicInfo.publishedAt ?? '',

      assets: basicInfo.assets
          .map(
            (e) => ContentAssetUiData(
              id: e.id,
              url: e.url,
              position: e.position,
            ),
          )
          .toList(),

      publisher: ContentPublisherUiData(

        id: publisher.id,

        name: publisher.name,

        avatarUrl: publisher.avatarUrl,

        followersCount: publisher.followersCount,

        followingCount: publisher.followingCount,

        publishedTestsCount:
            publisher.publishedTestsCount,

        isVerified:
            viewerState.creatorIsAcademicallyVerified,

      ),

      viewerHasLiked:
          viewerState.viewerHasLiked,

      viewerHasBookmarked:
          viewerState.viewerHasBookmarked,

      viewerIsFollowingCreator:
          viewerState.viewerIsFollowingCreator,

    );
  }
}