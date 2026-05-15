import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  Future<void> init({
    required void Function(String slug) onTestSlugReceived,
  }) async {
    debugPrint("============ DeepLinkService.init ============");

    final initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      debugPrint("→ initial deep link: $initialUri");
      _handleUri(initialUri, onTestSlugReceived);
    }

    _subscription = _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint("→ stream deep link: $uri");
        _handleUri(uri, onTestSlugReceived);
      },
      onError: (error) {
        debugPrint("✗ deep link stream error: $error");
      },
    );

    debugPrint("=================================================");
  }

  void _handleUri(Uri uri, void Function(String slug) onTestSlugReceived) {
    debugPrint("============ DeepLinkService._handleUri ============");
    debugPrint("→ uri: $uri");
    debugPrint("→ scheme: ${uri.scheme}");
    debugPrint("→ host: ${uri.host}");
    debugPrint("→ pathSegments: ${uri.pathSegments}");

    if (uri.scheme != 'nerd') {
      debugPrint("✗ ignored: invalid scheme");
      debugPrint("=================================================");
      return;
    }

    if (uri.host != 'tests') {
      debugPrint("✗ ignored: invalid host");
      debugPrint("=================================================");
      return;
    }

    if (uri.pathSegments.isEmpty) {
      debugPrint("✗ ignored: missing slug");
      debugPrint("=================================================");
      return;
    }

    final slug = uri.pathSegments.first.trim();

    if (slug.isEmpty) {
      debugPrint("✗ ignored: empty slug");
      debugPrint("=================================================");
      return;
    }

    debugPrint("✓ test slug received: $slug");
    debugPrint("=================================================");

    onTestSlugReceived(slug);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
