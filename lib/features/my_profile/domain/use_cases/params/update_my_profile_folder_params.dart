class UpdateMyProfileFolderParams {
  final int folderId;
  final String name;
  final String colorCode;
  final String? visibilityType;
  final List<int> testIds;

  const UpdateMyProfileFolderParams({
    required this.folderId,
    required this.name,
    required this.colorCode,
    this.visibilityType,
    required this.testIds,
  });
  Map<String, dynamic> toBody() {
    final body = {
      'name': name.trim(),
      'color_code': colorCode.trim(),
      'test_ids': testIds,
    };

    if (visibilityType != null) {
      body['visibility_type'] = visibilityType!.trim();
    }

    return body;
  }
}
