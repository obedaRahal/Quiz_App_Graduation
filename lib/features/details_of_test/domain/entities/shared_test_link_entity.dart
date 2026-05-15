class SharedTestLinkEntity {
  final bool success;
  final String title;
  final int statusCode;
  final SharedTestLinkDataEntity data;

  const SharedTestLinkEntity({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.data,
  });
}

class SharedTestLinkDataEntity {
  final int testId;
  final bool isOwner;

  const SharedTestLinkDataEntity({
    required this.testId,
    required this.isOwner,
  });
}