class ContentShareLinkEntity {
  final bool success;
  final String title;
  final int statusCode;
  final String shareSlug;
  final String shareUrl;

  const ContentShareLinkEntity({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.shareSlug,
    required this.shareUrl,
  });
}

class SharedContentLinkEntity {
  final bool success;
  final String title;
  final int statusCode;
  final int materialId;
  final bool isOwner;

  const SharedContentLinkEntity({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.materialId,
    required this.isOwner,
  });
}
