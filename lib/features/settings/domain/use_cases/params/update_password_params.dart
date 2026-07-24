class UpdatePasswordParams {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const UpdatePasswordParams({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    };
  }
}
