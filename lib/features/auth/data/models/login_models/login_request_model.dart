class LoginRequestModel {
  final String email;
  final String password;
  final String? fcmToken;
  final String? deviceId;
  final String? deviceName;

  const LoginRequestModel({
    required this.email,
    required this.password,
    this.fcmToken,
    this.deviceId,
    this.deviceName,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'email': email, 'password': password};

    _addOptionalValue(json, key: 'fcm_token', value: fcmToken);
    _addOptionalValue(json, key: 'device_id', value: deviceId);
    _addOptionalValue(json, key: 'device_name', value: deviceName);

    return json;
  }
}

void _addOptionalValue(
  Map<String, dynamic> json, {
  required String key,
  required String? value,
}) {
  final normalized = value?.trim();
  if (normalized != null && normalized.isNotEmpty) {
    json[key] = normalized;
  }
}
