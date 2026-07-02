class OtherContentViewerStateEntity {
  final bool viewerHasLiked;
  final bool viewerHasBookmarked;
  final bool viewerIsFollowingCreator;
  final bool creatorIsAcademicallyVerified;

  const OtherContentViewerStateEntity({
    required this.viewerHasLiked,
    required this.viewerHasBookmarked,
    required this.viewerIsFollowingCreator,
    required this.creatorIsAcademicallyVerified,
  });
}