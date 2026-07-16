class CreateMyProfileFolderParams {
  final String name;
  final String colorCode;
  final String visibilityType;
  final List<int> testIds;

  const CreateMyProfileFolderParams({
    required this.name,
    required this.colorCode,
    required this.visibilityType,
    required this.testIds,
  });

  Map<String, dynamic> toBody() {
    return {
      'name': name.trim(),
      'color_code': colorCode.trim(),
      'visibility_type': visibilityType.trim(),
      'test_ids': testIds,
    };
  }
}
