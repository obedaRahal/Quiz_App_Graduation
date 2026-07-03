class EditMyProfilePersonalInfoParams {
  final int userId;
  final Map<String, dynamic> changedFields;

  const EditMyProfilePersonalInfoParams({
    required this.userId,
    required this.changedFields,
  });
}