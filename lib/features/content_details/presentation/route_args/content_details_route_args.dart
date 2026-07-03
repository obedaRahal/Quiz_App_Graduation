class ContentDetailsRouteArgs {
  final int contentId;
  final bool isMyContent;

  const ContentDetailsRouteArgs({
    required this.contentId,
    this.isMyContent = false,
  });
}