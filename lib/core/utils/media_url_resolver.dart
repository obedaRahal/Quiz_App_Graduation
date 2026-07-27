import 'package:quiz_app_grad/core/database/api/end_point.dart';

String resolveMediaUrl(
  String rawUrl, {
  String apiBaseUrl = EndPoints.baseUrl,
}) {
  final mediaUrl = rawUrl.trim();
  if (mediaUrl.isEmpty) return mediaUrl;

  final mediaUri = Uri.tryParse(mediaUrl);
  if (mediaUri == null) return mediaUrl;

  final mediaHost = mediaUri.host.toLowerCase();
  if (mediaHost != 'localhost' && mediaHost != '127.0.0.1') {
    return mediaUrl;
  }

  final apiUri = Uri.tryParse(apiBaseUrl);
  if (apiUri == null || apiUri.host.isEmpty) {
    return mediaUrl;
  }

  return mediaUri
      .replace(
        scheme: apiUri.scheme,
        host: apiUri.host,
        port: apiUri.hasPort ? apiUri.port : null,
      )
      .toString();
}
