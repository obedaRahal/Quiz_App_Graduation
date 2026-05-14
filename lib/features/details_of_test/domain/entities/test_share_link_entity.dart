class TestShareLinkEntity {
  final bool success;
  final String title;
  final int statusCode;
  final TestShareLinkDataEntity data;

  const TestShareLinkEntity({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.data,
  });
}

class TestShareLinkDataEntity {
  final String shareSlug;
  final String shareUrl;

  const TestShareLinkDataEntity({
    required this.shareSlug,
    required this.shareUrl,
  });
}