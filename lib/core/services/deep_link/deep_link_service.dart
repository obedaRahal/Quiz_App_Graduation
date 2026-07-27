import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

enum AppDeepLinkKind { test, library, profile }

class AppDeepLinkTarget {
  final AppDeepLinkKind kind;
  final String slug;

  const AppDeepLinkTarget({required this.kind, required this.slug});
}

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  Future<void> init({
    required void Function(String slug) onTestSlugReceived,
    required void Function(String slug) onLibrarySlugReceived,
    required void Function(String slug) onProfileSlugReceived,
  }) async {
    debugPrint("============ DeepLinkService.init ============");

    await _subscription?.cancel();
    _subscription = null;

    final initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      debugPrint("→ initial deep link: $initialUri");
      _handleUri(
        initialUri,
        onTestSlugReceived: onTestSlugReceived,
        onLibrarySlugReceived: onLibrarySlugReceived,
        onProfileSlugReceived: onProfileSlugReceived,
      );
    }

    _subscription = _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint("→ stream deep link: $uri");
        _handleUri(
          uri,
          onTestSlugReceived: onTestSlugReceived,
          onLibrarySlugReceived: onLibrarySlugReceived,
          onProfileSlugReceived: onProfileSlugReceived,
        );
      },
      onError: (error) {
        debugPrint("✗ deep link stream error: $error");
      },
    );

    debugPrint("=================================================");
  }

  static AppDeepLinkTarget? parseUri(Uri uri) {
    if (uri.scheme != 'nerd' || uri.pathSegments.isEmpty) {
      return null;
    }

    final slug = uri.pathSegments.first.trim();
    if (slug.isEmpty) return null;

    final kind = switch (uri.host) {
      'tests' => AppDeepLinkKind.test,
      'library' => AppDeepLinkKind.library,
      'profiles' => AppDeepLinkKind.profile,
      _ => null,
    };

    return kind == null ? null : AppDeepLinkTarget(kind: kind, slug: slug);
  }

  void _handleUri(
    Uri uri, {
    required void Function(String slug) onTestSlugReceived,
    required void Function(String slug) onLibrarySlugReceived,
    required void Function(String slug) onProfileSlugReceived,
  }) {
    debugPrint("============ DeepLinkService._handleUri ============");
    debugPrint("→ uri: $uri");
    debugPrint("→ scheme: ${uri.scheme}");
    debugPrint("→ host: ${uri.host}");
    debugPrint("→ pathSegments: ${uri.pathSegments}");

    final target = parseUri(uri);
    if (target == null) {
      debugPrint("✗ ignored: unsupported or malformed deep link");
      debugPrint("=================================================");
      return;
    }

    debugPrint("✓ deep link kind: ${target.kind.name}");
    debugPrint("✓ slug received: ${target.slug}");
    debugPrint("=================================================");

    switch (target.kind) {
      case AppDeepLinkKind.test:
        onTestSlugReceived(target.slug);
      case AppDeepLinkKind.library:
        onLibrarySlugReceived(target.slug);
      case AppDeepLinkKind.profile:
        onProfileSlugReceived(target.slug);
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
