class ContentDetailsRouteArgs {
  final int contentId;
  final bool isMyContent;
  final bool isMyPublicContent;

  const ContentDetailsRouteArgs({
    required this.contentId,
    this.isMyContent = false,
    this.isMyPublicContent = true,
  });
}
