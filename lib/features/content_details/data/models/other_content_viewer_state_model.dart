import '../../domain/entities/other_content_viewer_state_entity.dart';

class OtherContentViewerStateModel extends OtherContentViewerStateEntity {
  const OtherContentViewerStateModel({
    required super.viewerHasLiked,
    required super.viewerHasBookmarked,
    required super.viewerIsFollowingCreator,
    required super.creatorIsAcademicallyVerified,
  });

  factory OtherContentViewerStateModel.fromJson(Map<String, dynamic> json) {
    return OtherContentViewerStateModel(
      viewerHasLiked: json['viewer_has_liked'] ?? false,
      viewerHasBookmarked: json['viewer_has_bookmarked'] ?? false,
      viewerIsFollowingCreator:
          json['viewer_is_following_creator'] ?? false,
      creatorIsAcademicallyVerified:
          json['creator_is_academically_verified'] ?? false,
    );
  }
}