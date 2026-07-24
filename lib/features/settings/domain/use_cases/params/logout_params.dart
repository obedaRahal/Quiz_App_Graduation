class LogoutParams {
  final String? fcmToken;
  final String? deviceId;

  const LogoutParams({this.fcmToken, this.deviceId});

  Map<String, dynamic> toJson() {
    return {'fcm_token': fcmToken, 'device_id': deviceId};
  }
}
