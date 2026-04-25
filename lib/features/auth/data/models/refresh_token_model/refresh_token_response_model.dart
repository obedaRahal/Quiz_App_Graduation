class RefreshTokenResponseModel {
  final bool success;
  final String title;
  final String newToken;
  final int expiresIn;
  final int statusCode;

  const RefreshTokenResponseModel({
    required this.success,
    required this.title,
    required this.newToken,
    required this.expiresIn,
    required this.statusCode,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return RefreshTokenResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      newToken: data['newToken'] ?? '',
      expiresIn: data['expires_in'] ?? 0,
      statusCode: json['status_code'] ?? 0,
    );
  }
}