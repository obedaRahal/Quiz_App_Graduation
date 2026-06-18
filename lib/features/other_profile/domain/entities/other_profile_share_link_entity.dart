class OtherProfileShareLinkEntity {
  final bool success;
  final String title;
  final OtherProfileShareLinkDataEntity data;
  final int statusCode;

  const OtherProfileShareLinkEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class OtherProfileShareLinkDataEntity {
  final String shareSlug;
  final String shareUrl;

  const OtherProfileShareLinkDataEntity({
    required this.shareSlug,
    required this.shareUrl,
  });
}